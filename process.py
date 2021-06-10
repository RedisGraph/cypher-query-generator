import os
import argparse
import subprocess
from time import time
from RLTest import Env
from redisgraph import Graph
from grammarinator import generate


def make_connection():
    env = Env(decodeResponses=True)
    redis_con = env.getConnection()
    return Graph("G", redis_con)


def issue_queries(graph, timeout):
    working_dir = os.path.dirname(os.path.abspath(__file__))
    env = dict(os.environ, PYTHONPATH=os.pathsep.join([os.environ.get('PYTHONPATH', ''), working_dir + "/generator"]))
    cmd = ["python3 grammarinator/grammarinator/generate.py CustomCypherGenerator.CustomCypherGenerator --sys-path generator/ --jobs 1 -r oC_Query -o stdout -d 30"]

    start = time()
    while time() - start < timeout:
        sub = subprocess.run(cmd, capture_output=True, env=env, shell=True, encoding="utf8")
        # Capture generated queries
        query = sub.stdout
        # Exit early if generator failed
        if sub.stderr:
            print(sub.stderr)
            exit(1)

        # Log query to console
        print(query)
        try:
            graph.query(query, timeout=1000)
        except Exception as e:
            print("Encountered exception: %s" % str(e))


def runner():
    # Parse arguments
    parser = argparse.ArgumentParser()
    parser.add_argument("-t", "--timeout", type=int, default=30, help="timeout value in seconds")
    args = parser.parse_args()
    timeout = args.timeout

    graph = make_connection()

    issue_queries(graph, timeout)


# Invoke
runner()
