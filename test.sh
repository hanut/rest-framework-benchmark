#!/bin/bash
curl -XPOST -H "Content-type: application/json" \
  -d '{"email": "hanutsingh@gmail.com", "password": "qweasd@123"}' \
  'http://localhost:3000' && echo ""