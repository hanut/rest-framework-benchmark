#!/bin/bash

mkdir -p results

NUM_WORKERS=5

# Get framework text label from framework shortcode
FLabel() {
  case $1 in
  bun)
    echo "Bun + Express"
    ;;
  node)
    echo "Node + Express" 
    ;;
  neste)
    echo "Nest + Express"
    ;;
  nestf)
    echo "Nest + Fastify"
    ;;
  go)
    echo "Go + Fiber"
    ;;
  cpp)
    echo "Cpp & Oat++"
    ;;
  rust)
    echo "Rust + Actix"
    ;;
  *)
    echo "INVALID FRAMEWORK > $1"
    exit
    ;;
  esac
}

# Benchmark Function
Benchmark() {
  local framework="$1"
  local flabel=$(FLabel $1)
  echo "Running $flabel benchmark"
  rm  -f ./results/$framework-10k.txt ./results/$framework-100k.txt ./results/$framework-1m.txt
  echo "starting $framework server..."
  case $1 in
  bun)
    StartBun
    ;;
  node)
    StartNode 
    ;;
  neste)
    StartNestExpress
    ;;
  nestf)
    StartNestFastify
    ;;
  go)
    StartGo
    ;;
  cpp)
    StartCpp
    ;;
  rust)
    StartRust
    ;;

  *)
    exit
    ;;
  esac
  while ! curl http://localhost:3000 &> /dev/null; do
    echo "waiting for $flabel to start..."
    sleep 1
  done
  echo "$flabel started !"
  sleep 1
  echo "10k requests with $NUM_WORKERS workers"
  ab -k -n 10000 -c $NUM_WORKERS -q -p test_payload.json -T application/json http://localhost:3000/ >./results/$framework-10k.txt
  sleep 3
  echo "100k requests with $NUM_WORKERS workers"
  ab -k -n 100000 -c $NUM_WORKERS*2 -q -p test_payload.json -T application/json http://localhost:3000/ >./results/$framework-100k.txt
  sleep 3
  echo "1m requests with $NUM_WORKERS workers"
  ab -k -n 1000000 -c $NUM_WORKERS*3 -q -p test_payload.json -T application/json http://localhost:3000/ >./results/$framework-1m.txt
  echo "stopping server..."
  fuser -k 3000/tcp
}



# Bun benchmarks
StartBun() {
  bun ./bun/server.ts > /dev/null & server_pid=$!
}

# node benchmarks
StartNode() {
  cd ./node && npm run build
  node . > /dev/null & server_pid=$!
  cd ..
}

# Nest+Express benchmarks
StartNestExpress() {
  cd ./nest-express && npm run build
  node ./dist/main.js > /dev/null & server_pid=$!
  cd ..
}

# Nest+Fastify benchmarks
StartNestFastify() {
  cd ./nest-fastify && npm run build
  node ./dist/main.js > /dev/null & server_pid=$!
  cd ..
}

# go-fiber benchmarks
StartGo() {
  cd ./go-fiber
  go run main.go > /dev/null & server_pid=$!
  cd ..
}

# oat++ benchmarks
StartCpp() {
  cd ./cpp-oat
  mkdir -p build
  cd ./build && cmake .. && make
  ./simple-http > /dev/null & server_pid=$!
  cd ../../
}

# rust+actix benchmarks
StartRust() {
  cd ./rust-actix
  cargo run > /dev/null & server_pid=$!
  cd ..
}

Benchmark bun
sleep 5
Benchmark node
sleep 5
Benchmark neste
sleep 5
Benchmark nestf
sleep 5
Benchmark go
sleep 5
Benchmark cpp
sleep 5
Benchmark rust
