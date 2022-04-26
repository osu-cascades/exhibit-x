echo "Building binary..."
cargo build --release
echo "Done!"
echo "Copying binary to /usr/bin..."
sudo cp ./target/release/sketch_runner /usr/bin/sketch_runner