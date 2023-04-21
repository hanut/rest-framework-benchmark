#!/bin/bash

mkdir -p results

NUM_WORKERS=10
WAIT_BETWEEN_TESTS=3

# Benchmark Function
# The first parameter $1 has the framework tag like go, rust, bune etc
# The second parameter $2 has the order of output for the report
Benchmark() {
  local framework="$1"
  local flabel=""
  printf -v order "%05d" $2 # Store the order of the report

  case $1 in
  bune)
    flabel="Bun + Express"
    StartBunExpress
    ;;
  bunh)
    flabel="Bun + Hono"
    StartBunHono
    ;;
  denoe)
    flabel="Deno + Express"
    StartDenoExpress
    ;;
  denoo)
    flabel="Deno + Oak"
    StartDenoOak
    ;;
  nodex)
    flabel="Node + Express" 
    StartNodeExpress 
    ;;
  nodef)
    flabel="Node + Fastify" 
    StartNodeFastify 
    ;;
  neste)
    flabel="Nest + Express"
    StartNestExpress
    ;;
  nestf)
    flabel="Nest + Fastify"
    StartNestFastify
    ;;
  go)
    flabel="Go + Fiber"
    StartGo
    ;;
  cpp)
    flabel="Cpp & Oat++"
    StartCpp
    ;;
  rust)
    flabel="Rust + Actix"
    StartRust
    ;;
  javasp)
    flabel="Java + Springboot"
    StartJavaSpring
    ;;
  *)
    echo "INVALID FRAMEWORK > $1"
    exit
    ;;
  esac
  echo "$2. Running $flabel benchmark"
  let maxWait=10
  while ! curl http://localhost:3000 &> /dev/null; do
    if [ $maxWait -le 0 ]
    then
      echo $flabel server timed out
      exit 1
    fi
    echo "waiting for $flabel to start..."
    sleep 1
    let maxWait=maxWait-1
  done
  echo "$flabel service started !"
  
  sleep 1

  for (( c=1; c<=3; c++ ))
  do 
    local wrkrs=$((NUM_WORKERS*c))
    local rc=$((1000*(10**c)))
    local filename=./results/$order_$framework-$rc.txt
    
    echo "$rc requests with $wrkrs workers (results dumped at $filename)"
    # rm  -f ./results/$framework-$rc.txt
    ab -k -n $rc -c $wrkrs -q -p test_payload.json -T application/json http://localhost:3000/ >$filename
    printf "\nTest Label:$flabel\nTest Load:$rc\n">>$filename
    sleep 3
  done
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
  ./mvnw deploy
  java -jar ./target/simplerest-0.0.1-SNAPSHOT.jar > /dev/null & server_pid=$!
  cd ..
}

# Declare an array of frameworks to test. We can modify this
# to play around with which reports are generated  and in 
# which order
declare -a Frameworks=(
  # "bune"
  # "denoe"
  # "denoo"
  # "nodex"
  # "nodef"
  # "neste"
  # "nestf"
  # "go"
  # "cpp"
  # "rust"
  "javasp"
)
let order=1 
for fw in ${Frameworks[@]}; do
  Benchmark $fw $order
  sleep $WAIT_BETWEEN_TESTS
done

./process
