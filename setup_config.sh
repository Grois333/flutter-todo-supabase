#!/bin/bash

echo "Setting up the project..."

# Copy .env.example to .env if not exists
if [ ! -f .env ]; then
    cp .env.example .env
    echo "Copied .env.example to .env"
else
    echo ".env already exists, skipping copy"
fi

if [ ! -f ios/Flutter/GeneratedEnv.xcconfig ]; then
    cp GeneratedEnv.xcconfig.example ios/Flutter/GeneratedEnv.xcconfig
    echo "Copied GeneratedEnv.xcconfig.example to ios/Flutter/GeneratedEnv.xcconfig"
else
    echo "GeneratedEnv.xcconfig already exists, skipping copy"
fi

echo "Setup complete!"
