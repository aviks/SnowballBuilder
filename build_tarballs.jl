using BinaryBuilder

# These are the platforms built inside the wizard
platforms = [
    BinaryProvider.Linux(:i686, :glibc),
  BinaryProvider.Linux(:x86_64, :glibc),
  BinaryProvider.Linux(:aarch64, :glibc),
  BinaryProvider.Linux(:armv7l, :glibc),
  BinaryProvider.Linux(:powerpc64le, :glibc),
  BinaryProvider.MacOS(),
  BinaryProvider.Windows(:i686),
  BinaryProvider.Windows(:x86_64)
]


# If the user passed in a platform (or a few, comma-separated) on the
# command-line, use that instead of our default platforms
if length(ARGS) > 0
    platforms = platform_key.(split(ARGS[1], ","))
end
info("Building for $(join(triplet.(platforms), ", "))")

# Collection of sources required to build LibStemmer
sources = [
    "https://github.com/zvelo/libstemmer.git" =>
    "78c149a3a6f262a35c7f7351d3f77b725fc646cf",
]

script = raw"""
cd $WORKSPACE/srcdir
cd libstemmer/
sed -i -e 's/ADD_LIBRARY(stemmer/ADD_LIBRARY(stemmer SHARED/' CMakeLists.txt
sed -i -e 's/DESTINATION lib/RUNTIME DESTINATION bin LIBRARY DESTINATION lib/' CMakeLists.txt
cmake -DCMAKE_INSTALL_PREFIX=/ -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain
make
make install

"""

products = prefix -> [
    LibraryProduct(prefix,"libstemmer", :libstemmer)
]


# Build the given platforms using the given sources
hashes = autobuild(pwd(), "LibStemmer", platforms, sources, script, products)
