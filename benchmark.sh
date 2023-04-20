#!/bin/bash

mkdir -p results

NUM_WORKERS=10
WAIT_BETWEEN_TESTS=3

# Get framework text label from framework shortcode
FLabel() {
  case $1 in
  bune)
    echo "Bun + Express"
    ;;
  bunh)
    echo "Bun + Hono"
    ;;
  denoe)
    echo "Deno + Express"
    ;;
  denoo)
    echo "Deno + Oak"
    ;;
  nodex)
    echo "Node + Express" 
    ;;
  nodef)
    echo "Node + Fastify" 
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
  javasp)
    echo "Java + Springboot"
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
  bune)
    StartBunExpress
    ;;
  bunh)
    StartBunHono
    ;;
  denoe)
    StartDenoExpress
    ;;
  denoo)
    StartDenoOak
    ;;
  nodex)
    StartNodeExpress 
    ;;
  nodef)
    StartNodeFastify 
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
  javasp)
    StartJavaSpring
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
  local wrkrs=$NUM_WORKERS
  echo "10k requests with $wrkrs workers"
  ab -k -n 10000 -c $wrkrs -q -p test_payload.json -T application/json http://localhost:3000/ >./results/$framework-10k.txt
  sleep 3
  local wrkrs=$NUM_WORKERS*2
  echo "100k requests with $wrkrs workers"
  ab -k -n 100000 -c $wrkrs -q -p test_payload.json -T application/json http://localhost:3000/ >./results/$framework-100k.txt
  sleep 3
  local wrkrs=$NUM_WORKERS*3
  echo "1m requests with $wrkrs workers"
  ab -k -n 1000000 -c $wrkrs -q -p test_payload.json -T application/json http://localhost:3000/ >./results/$framework-1m.txt
  echo "stopping server..."
  fuser -k 3000/tcp
}



# Bun Express benchmarks
StartBunExpress() {
  bun ./bun-express/server.ts > /dev/null & server_pid=$!
}
# Bun Hono benchmarks
StartBunHono() {
  bun ./bun-hono/server.ts > /dev/null & server_pid=$!
}
# Deno Express benchmarks
StartDenoExpress() {
  deno run -A ./deno-express/main.ts > /dev/null & server_pid=$!
}
# Deno Oak benchmarks
StartDenoOak() {
  deno run -A ./deno-oak/main.ts > /dev/null & server_pid=$!
}

# node express benchmarks
StartNodeExpress() {
  cd ./node-express && npm run build
  node . > /dev/null & server_pid=$!
  cd ..
}
# node fastify benchmarks
StartNodeFastify() {
  cd ./node-fastify && npm run build
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
  go build -o go-fiber main.go
  ./go-fiber > /dev/null & server_pid=$!
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
  cargo build -r
  ./target/release/rust-actix > /dev/null & server_pid=$!
  cd ..
}

# rust+actix benchmarks
StartJavaSpring() {
  cd ./java-spring
   > /dev/null & server_pid=$!
  cd ..
}

declare -a Frameworks=(
  # "bune"
  # "denoe"
  # "denoo"
  # "nodex"
  # "nodef"
  # "neste"
  # "nestf"
  "go"
  # "cpp"
  # "rust"
  # "javasp"
)

for fw in ${Frameworks[@]}; do
  Benchmark $fw
  sleep $WAIT_BETWEEN_TESTS
done

./process
