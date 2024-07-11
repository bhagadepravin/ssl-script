#!/bin/bash

if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root"
  exit
fi

INTERMEDIATE_DIR="/root/ca/intermediate"
ROOT_CA_CERT="/root/ca/certs/ca.cert.pem"  # Update this path if needed
SERVER_NAME=$1
EXPORT_DIR=$2

# Ensure export directory exists
mkdir -p $EXPORT_DIR

# Copy server certificate
cp $INTERMEDIATE_DIR/certs/$SERVER_NAME.cert.pem $EXPORT_DIR/$SERVER_NAME.cert.pem

# Copy server private key
cp $INTERMEDIATE_DIR/private/$SERVER_NAME.key.pem $EXPORT_DIR/$SERVER_NAME.key.pem

# Copy intermediate certificate
cp $INTERMEDIATE_DIR/certs/intermediate.cert.pem $EXPORT_DIR/intermediate.cert.pem

# Copy root CA certificate
cp $ROOT_CA_CERT $EXPORT_DIR/ca.cert.pem

# Create full chain file
cat $EXPORT_DIR/$SERVER_NAME.cert.pem \
    $EXPORT_DIR/intermediate.cert.pem \
    $EXPORT_DIR/ca.cert.pem > $EXPORT_DIR/$SERVER_NAME.fullchain.cert.pem

# Verify permissions
chmod 444 $EXPORT_DIR/$SERVER_NAME.cert.pem
chmod 400 $EXPORT_DIR/$SERVER_NAME.key.pem
chmod 444 $EXPORT_DIR/intermediate.cert.pem
chmod 444 $EXPORT_DIR/ca.cert.pem
chmod 444 $EXPORT_DIR/$SERVER_NAME.fullchain.cert.pem

echo "Certificates and key have been exported to $EXPORT_DIR"
