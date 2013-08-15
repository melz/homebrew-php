require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php55Phalcon < AbstractPhp55Extension
  init
  homepage 'http://phalconphp.com/'
  url 'https://github.com/phalcon/cphalcon/archive/v1.2.3.tar.gz'
  sha1 'a8e74efa92f131cbd08fc32e042da8c3be706485'
  head 'git://github.com/phalcon/cphalcon.git'

  depends_on 'pcre'

  def install
    if MacOS.prefer_64_bit?
      Dir.chdir 'build/64bits'
    else
      Dir.chdir 'build/32bits'
    end

    ENV.universal_binary if build.universal?
    ENV.gcc
    ENV['CFLAGS'] = '-O2 -fno-delete-null-pointer-checks -finline-functions -fomit-frame-pointer'

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--enable-phalcon"
    system "make"
    prefix.install "modules/phalcon.so"
    write_config_file unless build.include? "without-config-file"
  end
end
