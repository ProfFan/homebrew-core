class Ffmpeg < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  head "https://github.com/FFmpeg/FFmpeg.git"

  stable do
    url "https://ffmpeg.org/releases/ffmpeg-3.2.4.tar.bz2"
    sha256 "c0fa3593a2e9e96ace3c1757900094437ad96d1d6ca19f057c378b5f394496a4"

    option "with-libebur128", "Enable using libebur128 for EBU R128 loudness measurement"

    # only vendored in head
    depends_on "libebur128" => :optional
  end

  bottle do
    sha256 "c4d1d895fca521400a0f6d27d7dfa3553ebda8c0f6c90fcd44a5b55aefe27aa4" => :sierra
    sha256 "c0ca7c202d7051596be029aeaec362b7faa8dae900eb1c4f5a4d00c86d2000f7" => :el_capitan
    sha256 "b07df0bf4f6c7402730d710b92758054941c8b437fa742c09a706115c8fc39e5" => :yosemite
    sha256 "b12a694db0bdf820d25f2d661284b20d95a73ee09fb1fcb1296ea5eb7e5ddb59" => :x86_64_linux
  end

  option "with-chromaprint", "Enable the Chromaprint audio fingerprinting library"
  option "with-fdk-aac", "Enable the Fraunhofer FDK AAC library"
  option "with-libass", "Enable ASS/SSA subtitle format"
  option "with-libsoxr", "Enable the soxr resample library"
  option "with-libssh", "Enable SFTP protocol via libssh"
  option "with-tesseract", "Enable the tesseract OCR engine"
  option "with-libvidstab", "Enable vid.stab support for video stabilization"
  option "with-opencore-amr", "Enable Opencore AMR NR/WB audio format"
  option "with-openh264", "Enable OpenH264 library"
  option "with-openjpeg", "Enable JPEG 2000 image format"
  option "with-openssl", "Enable SSL support"
  option "with-rtmpdump", "Enable RTMP protocol"
  option "with-rubberband", "Enable rubberband library"
  option "with-schroedinger", "Enable Dirac video format"
  option "with-sdl2", "Enable FFplay media player"
  option "with-snappy", "Enable Snappy library"
  option "with-tools", "Enable additional FFmpeg tools"
  option "with-webp", "Enable using libwebp to encode WEBP images"
  option "with-x265", "Enable x265 encoder"
  option "with-xz", "Enable decoding of LZMA-compressed TIFF files"
  option "with-zeromq", "Enable using libzeromq to receive commands sent through a libzeromq client"
  option "with-zimg", "Enable z.lib zimg library"
  option "without-lame", "Disable MP3 encoder"
  option "without-qtkit", "Disable deprecated QuickTime framework"
  option "without-securetransport", "Disable use of SecureTransport"
  option "without-x264", "Disable H.264 encoder"
  option "without-xvid", "Disable Xvid MPEG-4 video encoder"

  deprecated_option "with-ffplay" => "with-sdl2"
  deprecated_option "with-sdl" => "with-sdl2"
  deprecated_option "with-libtesseract" => "with-tesseract"

  depends_on "pkg-config" => :build
  depends_on "texi2html" => :build
  depends_on "yasm" => :build

  depends_on "lame" => :recommended
  depends_on "x264" => :recommended
  depends_on "xvid" => :recommended
  depends_on "zlib" unless OS.mac?
  depends_on "bzip2" unless OS.mac?
  depends_on "xz" => :recommended unless OS.mac?

  depends_on "chromaprint" => :optional
  depends_on "fdk-aac" => :optional
  depends_on "fontconfig" => :optional
  depends_on "freetype" => :optional
  depends_on "frei0r" => :optional
  depends_on "game-music-emu" => :optional
  depends_on "libass" => :optional
  depends_on "libbluray" => :optional
  depends_on "libbs2b" => :optional
  depends_on "libcaca" => :optional
  depends_on "libgsm" => :optional
  depends_on "libmodplug" => :optional
  depends_on "libsoxr" => :optional
  depends_on "libssh" => :optional
  depends_on "libvidstab" => :optional
  depends_on "libvorbis" => :optional
  depends_on "libvpx" => :optional
  depends_on "opencore-amr" => :optional
  depends_on "openh264" => :optional
  depends_on "openjpeg" => :optional
  depends_on "openssl" => :optional
  depends_on "opus" => :optional
  depends_on "rtmpdump" => :optional
  depends_on "rubberband" => :optional
  depends_on "schroedinger" => :optional
  depends_on "sdl2" => :optional
  depends_on "snappy" => :optional
  depends_on "speex" => :optional
  depends_on "tesseract" => :optional
  depends_on "theora" => :optional
  depends_on "two-lame" => :optional
  depends_on "wavpack" => :optional
  depends_on "webp" => :optional
  depends_on "x265" => :optional
  depends_on "xz" => :optional
  depends_on "zeromq" => :optional
  depends_on "zimg" => :optional

  def install
    # Fixes "dyld: lazy symbol binding failed: Symbol not found: _clock_gettime"
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      inreplace %w[libavdevice/v4l2.c libavutil/time.c], "HAVE_CLOCK_GETTIME",
                                                         "UNDEFINED_GIBBERISH"
    end

    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-pthreads
      --enable-gpl
      --enable-version3
      --enable-hardcoded-tables
      --enable-avresample
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
    ]

    args << "--disable-indev=qtkit" if build.without? "qtkit"
    args << "--disable-securetransport" if build.without? "securetransport"
    args << "--enable-chromaprint" if build.with? "chromaprint"
    args << "--enable-ffplay" if build.with? "sdl2"
    args << "--enable-frei0r" if build.with? "frei0r"
    args << "--enable-libass" if build.with? "libass"
    args << "--enable-libbluray" if build.with? "libbluray"
    args << "--enable-libbs2b" if build.with? "libbs2b"
    args << "--enable-libcaca" if build.with? "libcaca"
    args << "--enable-libebur128" if build.stable? && build.with?("libebur128")
    args << "--enable-libfdk-aac" if build.with? "fdk-aac"
    args << "--enable-libfontconfig" if build.with? "fontconfig"
    args << "--enable-libfreetype" if build.with? "freetype"
    args << "--enable-libgme" if build.with? "game-music-emu"
    args << "--enable-libgsm" if build.with? "libgsm"
    args << "--enable-libmodplug" if build.with? "libmodplug"
    args << "--enable-libmp3lame" if build.with? "lame"
    args << "--enable-libopencore-amrnb" << "--enable-libopencore-amrwb" if build.with? "opencore-amr"
    args << "--enable-libopenh264" if build.with? "openh264"
    args << "--enable-libopus" if build.with? "opus"
    args << "--enable-librtmp" if build.with? "rtmpdump"
    args << "--enable-librubberband" if build.with? "rubberband"
    args << "--enable-libschroedinger" if build.with? "schroedinger"
    args << "--enable-libsnappy" if build.with? "snappy"
    args << "--enable-libsoxr" if build.with? "libsoxr"
    args << "--enable-libspeex" if build.with? "speex"
    args << "--enable-libssh" if build.with? "libssh"
    args << "--enable-libtesseract" if build.with? "tesseract"
    args << "--enable-libtheora" if build.with? "theora"
    args << "--enable-libtwolame" if build.with? "two-lame"
    args << "--enable-libvidstab" if build.with? "libvidstab"
    args << "--enable-libvorbis" if build.with? "libvorbis"
    args << "--enable-libvpx" if build.with? "libvpx"
    args << "--enable-libwavpack" if build.with? "wavpack"
    args << "--enable-libwebp" if build.with? "webp"
    args << "--enable-libx264" if build.with? "x264"
    args << "--enable-libx265" if build.with? "x265"
    args << "--enable-libxvid" if build.with? "xvid"
    args << "--enable-libzimg" if build.with? "zimg"
    args << "--enable-libzmq" if build.with? "zeromq"
    args << "--enable-opencl" if MacOS.version > :lion
    args << "--enable-openssl" if build.with? "openssl"

    if build.with? "xz"
      args << "--enable-lzma"
    else
      args << "--disable-lzma"
    end

    if build.with? "openjpeg"
      args << "--enable-libopenjpeg"
      args << "--disable-decoder=jpeg2000"
      args << "--extra-cflags=" + `pkg-config --cflags libopenjp2`.chomp
    end

    # These librares are GPL-incompatible, and require ffmpeg be built with
    # the "--enable-nonfree" flag, which produces unredistributable libraries
    if %w[fdk-aac openssl].any? { |f| build.with? f }
      args << "--enable-nonfree"
    end

    # A bug in a dispatch header on 10.10, included via CoreFoundation,
    # prevents GCC from building VDA support. GCC has no problems on
    # 10.9 and earlier.
    # See: https://github.com/Homebrew/homebrew/issues/33741
    if MacOS.version < :yosemite || ENV.compiler == :clang
      args << "--enable-vda"
    else
      args << "--disable-vda"
    end

    # For 32-bit compilation under gcc 4.2, see:
    # https://trac.macports.org/ticket/20938#comment:22
    ENV.append_to_cflags "-mdynamic-no-pic" if Hardware::CPU.is_32_bit? && Hardware::CPU.intel? && ENV.compiler == :clang

    system "./configure", *args

    if MacOS.prefer_64_bit?
      inreplace "config.mak" do |s|
        shflags = s.get_make_var "SHFLAGS"
        if shflags.gsub!(" -Wl,-read_only_relocs,suppress", "")
          s.change_make_var! "SHFLAGS", shflags
        end
      end
    end

    system "make", "install"

    if build.with? "tools"
      system "make", "alltools"
      bin.install Dir["tools/*"].select { |f| File.executable? f }
    end
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert mp4out.exist?
  end
end
