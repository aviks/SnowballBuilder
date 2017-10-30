using BinaryBuilder

platforms = [
BinaryProvider.Linux(:x86_64, :glibc),
BinaryProvider.MacOS(),
BinaryProvider.Windows(:x86_64)
]

sources = [
"6530c3638f29f5b03bc3786bb9212e39adaf3bf15b5b0a483b2eb5111f7f416e" =>
"http://snowball.tartarus.org/dist/libstemmer_c.tgz",
]

script = raw"""
cd libstemmer_c/
export CPPFLAGS="-fPIC"
make
$CC -shared -o libstemmer.so libstemmer.o
cp libstemmer.so $DESTDIR/
exit

"""

products = prefix -> [
	LibraryProduct(prefix,"libstemmer")
]

autobuild(pwd(), "", platforms, sources, script, products)
