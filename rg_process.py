import os
import redis
import subprocess
from redisgraph import Graph
from neo4j import GraphDatabase

r = redis.Redis(host='localhost', port=6379)
redis_graph = Graph('G', r)

neo4j_driver = GraphDatabase.driver("bolt:localhost:7687", auth=("neo4j", "admin"))
neo4j_session = neo4j_driver.session()


def neo4j_query(tx, query):
    x = tx.run(query)
    return x.values()


def neo4j_transaction(query):
    return neo4j_session.write_transaction(neo4j_query, query)


def compare_edges(rg_edge, neo_edge):
    assert(rg_edge.relation == neo_edge.type)
    assert(rg_edge.properties == neo_edge._properties)


def compare_nodes(rg_node, neo_node):
    assert(frozenset(rg_node.label) == neo_node.labels)
    assert(rg_node.properties == neo_node._properties)


def compare_elem(rg_elem, neo_elem):
    if(type(rg_elem).__name__ == 'Node'):
        compare_nodes(rg_elem, neo_elem)
    elif(type(rg_elem).__name__ == 'Edge'):
        compare_edges(rg_elem, neo_elem)
    else:
        assert(rg_elem == neo_elem)


def compare_results(rg_result, neo_result):
    assert(len(rg_result) == len(neo_result))
    for row_idx in range(len(rg_result)):
        rg_row = rg_result[row_idx]
        neo_row = neo_result[row_idx]
        assert(len(rg_row) == len(neo_row))
        for elem_idx in range(len(rg_row)):
            compare_elem(rg_row[elem_idx], neo_row[elem_idx])


working_dir = os.path.dirname(os.path.abspath(__file__))
env = dict(os.environ, PYTHONPATH=os.pathsep.join([os.environ.get('PYTHONPATH', ''), working_dir + "/generator"]))
cmd = ["grammarinator-generate CustomCypherGenerator.CustomCypherGenerator --sys-path generator/ --jobs 1 -r oC_Query -o stdout -d 30"]
while True:
    sub = subprocess.run(cmd, capture_output=True, env=env, shell=True, encoding="utf8")
    query = sub.stdout
    if sub.stderr:
        print(sub.stderr)
        exit(0)
    #  print(query)

    rg_result = []
    rg_exception = False
    rg_exception_msg = None
    try:
        rg_result = redis_graph.query(query).result_set
    except Exception as e:
        rg_exception = True
        rg_exception_msg = e.args

    neo_result = []
    neo_exception = False
    neo_exception_msg = None
    try:
        neo_result = neo4j_transaction(query)
    except Exception as e:
        neo_exception = True
        neo_exception_msg = e.message

    try:
        assert(rg_exception == neo_exception)
    except Exception as e:
        print("Query generated exception mismatch:")
        print(query)
        print("RedisGraph exception: %s" % (rg_exception_msg))
        print("Neo4j exception: %s" % (neo_exception_msg))
        raise e

    try:
        compare_results(rg_result, neo_result)
    except Exception as e:
        print("Query generated inequal results:")
        print(query)
        raise e
    #  if neo_result != []:
        #  print(neo_result)
    #  break # TODO tmp

neo4j_driver.close()
