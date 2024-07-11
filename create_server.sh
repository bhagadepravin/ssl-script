#!/bin/bash

if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root"
  exit
fi

INTERMEDIATE_DIR="/root/ca/intermediate"
ROOT_CA_CERT="/root/ca/certs/ca.cert.pem"  # Update this path if needed
SERVER_NAME=$1
SERVER_DIR="$INTERMEDIATE_DIR/$SERVER_NAME"

# Ensure directories exist
mkdir -p $SERVER_DIR/private
mkdir -p $SERVER_DIR/certs
mkdir -p $SERVER_DIR/csr

# Create key
openssl genrsa -out $SERVER_DIR/private/$SERVER_NAME.key.pem 2048
chmod 400 $SERVER_DIR/private/$SERVER_NAME.key.pem

# Create CSR
openssl req -config $INTERMEDIATE_DIR/openssl.cnf \
      -key $SERVER_DIR/private/$SERVER_NAME.key.pem \
      -new -sha256 -out $SERVER_DIR/csr/$SERVER_NAME.csr.pem

# Sign certificate
openssl ca -config $INTERMEDIATE_DIR/openssl.cnf \
      -extensions server_cert -days 375 -notext -md sha256 \
      -in $SERVER_DIR/csr/$SERVER_NAME.csr.pem \
      -out $SERVER_DIR/certs/$SERVER_NAME.cert.pem
chmod 444 $SERVER_DIR/certs/$SERVER_NAME.cert.pem

# View certificate
openssl x509 -noout -text \
      -in $SERVER_DIR/certs/$SERVER_NAME.cert.pem

# Verify certificate
openssl verify -CAfile $INTERMEDIATE_DIR/certs/ca-chain.cert.pem \
      $SERVER_DIR/certs/$SERVER_NAME.cert.pem

# Create chain file
cat $SERVER_DIR/certs/$SERVER_NAME.cert.pem \
      $INTERMEDIATE_DIR/certs/intermediate.cert.pem \
      $ROOT_CA_CERT > $SERVER_DIR/certs/$SERVER_NAME.fullchain.cert.pem
chmod 444 $SERVER_DIR/certs/$SERVER_NAME.fullchain.cert.pem
