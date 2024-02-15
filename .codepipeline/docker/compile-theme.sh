# Build the theme docker image
current_dir=$(dirname "$0")

echo "Building theme Docker image"
docker build -t cmfive-theme:latest -f $current_dir/theme.dockerfile .

# Compile production theme
echo "Compiling production theme"
current_dir=$(cd $current_dir && pwd)
mkdir -p $current_dir/theme
chmod 777 $current_dir/theme
docker run --rm -v "$current_dir/theme:/compiled:rw" cmfive-theme:latest
