# Cypher Query Generator
A tool for generating randomized openCypher queries that are frequently semantically correct.

## Installation
```
pip3 install --user grammarinator@https://github.com/jeffreylovitz/grammarinator  
```

## Usage

Emit query to stdout:
```
grammarinator-generate CustomCypherGenerator.CustomCypherGenerator --sys-path generator/ --jobs 1 -r oC_Query -o stdout -d 30
```

Run queries in infinite loop against local server:
```
grammarinator-generate CustomCypherGenerator.CustomCypherGenerator --sys-path generator/ --jobs 1 -r oC_Query -o stdout -d 30 --infinite | ./process_queries.sh
```