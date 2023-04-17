#!/bin/bash

mkdir -p results

# Bun benchmarks
BenchmarkBun() {
  echo "Running Bun + Express benchmarks"
  rm  -f ./results/bun-100k-result.txt ./results/bun-1m-result.txt
  echo "starting server..."
  bun ./bun/server.ts & server_pid=$!
  while ! curl http://localhost:3000 &> /dev/null; do
    sleep 1
  done
  sleep 2
  ab -k -n 100000 -c 100 -q -g ./results/bun-100k-result.txt  -p test_payload.json -T application/json http://localhost:3000/ >./results/bun-100k-result.txt 2>&1
  sleep 5
  ab -k -n 1000000 -c 100 -q -g ./results/bun-1m-result.txt  -p test_payload.json -T application/json http://localhost:3000/ >./results/bun-1m-result.txt 2>&1
  echo "stopping server..."
  fuser -k 3000/tcp
}

# node benchmarks
BenchmarkNode() {
  echo "Running Node + Express benchmarks"
  rm -f ./results/node-100k-result.txt ./results/node-1m-result.txt
  echo "starting server..."
  cd ./node && npm run build
  node . & server_pid=$!
  cd ..
  while ! curl http://localhost:3001 &> /dev/null; do
    sleep 1
  done
  ab -k -n 100000 -c 100 -q -g ./results/node-100k-result.txt  -p test_payload.json -T application/json http://localhost:3001/ >./results/node-100k-result.txt 2>&1 
  sleep 5
  ab -k -n 1000000 -c 100 -q -g ./results/node-1m-result.txt  -p test_payload.json -T application/json http://localhost:3001/ >./results/node-1m-result.txt 2>&1 
  echo "stopping server..."
  fuser -k 3001/tcp
}

# Nest+Express benchmarks
BenchmarkNestExpress() {
  echo "Running Nestjs + Express benchmarks"
  rm -f ./results/nest-express-100k-result.txt ./results/nest-express-1m-result.txt
  echo "building server..."
  cd ./nest-express && npm run build
  echo "starting server..."
  node ./dist/main.js & server_pid=$!
  cd ..
  while ! curl http://localhost:3000 &> /dev/null; do
    sleep 1
  done
  ab -k -n 100000 -c 100 -q -g ./results/nest-express-100k-result.txt  -p test_payload.json -T application/json http://localhost:3000/ >./results/nest-express-100k-result.txt 2>&1 
  sleep 5
  ab -k -n 1000000 -c 100 -q -g ./results/nest-express-1m-result.txt  -p test_payload.json -T application/json http://localhost:3000/ >./results/nest-express-1m-result.txt 2>&1 
  echo "stopping server..."
  fuser -k 3000/tcp
}


# go-fiber benchmarks
BenchmarkGo() {
  echo "Running Go + Fiber benchmarks"
  rm -f ./results/gofiber-100k-result.txt ./results/gofiber-1m-result.txt
  echo "starting server..."
  cd ./go-fiber
  go run main.go & server_pid=$!
  cd ..
  while ! curl http://localhost:3002 &> /dev/null; do
    sleep 1
  done
  ab -k -n 100000 -c 100 -q -g ./results/gofiber-100k-result.txt  -p test_payload.json -T application/json http://localhost:3002/ > ./results/gofiber-100k-result.txt 2>&1
  sleep 5
  ab -k -n 1000000 -c 100 -q -g ./results/gofiber-1m-result.txt  -p test_payload.json -T application/json http://localhost:3002/ > ./results/gofiber-1m-result.txt 2>&1
  echo "stopping server..."
  fuser -k 3002/tcp
}

# oat++ benchmarks
BenchmarkCpp() {
  echo "Running Oat++ benchmarks"
  rm -f ./results/cppoat-100k-result.txt ./results/cppoat-1m-result.txt
  echo "starting server..."
  cd ./cpp-oat
  mkdir -p build
  cd ./build && cmake .. && make
  ./simple-http & server_pid=$!
  cd ../../
  while ! curl http://localhost:3003 &> /dev/null; do
    sleep 1
  done
  ab -k -n 100000 -c 100 -q -g ./results/cppoat-100k-result.txt  -p test_payload.json -T application/json http://localhost:3003/ > ./results/cppoat-100k-result.txt 2>&1
  sleep 5
  ab -k -n 1000000 -c 100 -q -g ./results/cppoat-1m-result.txt  -p test_payload.json -T application/json http://localhost:3003/ > ./results/cppoat-1m-result.txt 2>&1
  echo "stopping server..."
  fuser -k 3003/tcp
}

# rust+actix benchmarks
BenchmarkRust() {
  echo "Running Rust + Actix benchmarks"
  rm -f ./results/actix-100k-result.txt ./results/actix-1m-result.txt
  echo "starting server..."
  cd ./rust-actix
  cargo run & server_pid=$!
  cd ..
  while ! curl http://localhost:3004 &> /dev/null; do
    sleep 1
  done
  ab -k -n 100000 -c 100 -q -g ./results/actix-100k-result.txt  -p test_payload.json -T application/json http://localhost:3004/ > ./results/actix-100k-result.txt 2>&1
  sleep 5
  ab -k -n 1000000 -c 100 -q -g ./results/actix-1m-result.txt  -p test_payload.json -T application/json http://localhost:3004/ > ./results/actix-1m-result.txt 2>&1
  echo "stopping server..."
  fuser -k 3004/tcp
}

# BenchmarkBun
# sleep 5
# BenchmarkNode
# sleep 5
BenchmarkNestExpress
# sleep 5
# BenchmarkGo
# sleep 5
# BenchmarkCpp
# sleep 5
# BenchmarkRust