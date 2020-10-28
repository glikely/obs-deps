#!/usr/bin/env bash

set -eE

PRODUCT_NAME="OBS Pre-Built Dependencies"
BASE_DIR="$(git rev-parse --show-toplevel)"

export COLOR_RED=$(tput setaf 1)
export COLOR_GREEN=$(tput setaf 2)
export COLOR_BLUE=$(tput setaf 4)
export COLOR_ORANGE=$(tput setaf 3)
export COLOR_RESET=$(tput sgr0)

export MAC_QT_VERSION="5.14.1"
export MAC_QT_HASH="6f17f488f512b39c2feb57d83a5e0a13dcef32999bea2e2a8f832f54a29badb8"
export LIBPNG_VERSION="1.6.37"
export LIBPNG_HASH="505e70834d35383537b6491e7ae8641f1a4bed1876dbfe361201fc80868d88ca"
export LIBOPUS_VERSION="1.3.1"
export LIBOPUS_HASH="65b58e1e25b2a114157014736a3d9dfeaad8d41be1c8179866f144a2fb44ff9d"
export LIBOGG_VERSION="1.3.4"
export LIBOGG_HASH="fe5670640bd49e828d64d2879c31cb4dde9758681bb664f9bdbf159a01b0c76e"
export LIBRNNOISE_VERSION="2020-07-28"
export LIBRNNOISE_HASH="90ec41ef659fd82cfec2103e9bb7fc235e9ea66c"
export LIBVORBIS_VERSION="1.3.7"
export LIBVORBIS_HASH="b33cc4934322bcbf6efcbacf49e3ca01aadbea4114ec9589d1b1e9d20f72954b"
export LIBVPX_VERSION="1.9.0"
export LIBVPX_HASH="d279c10e4b9316bf11a570ba16c3d55791e1ad6faa4404c67422eb631782c80a"
export LIBJANSSON_VERSION="2.13.1"
export LIBJANSSON_HASH="f4f377da17b10201a60c1108613e78ee15df6b12016b116b6de42209f47a474f"
export LIBX264_VERSION="r3018"
export LIBX264_HASH="db0d417728460c647ed4a847222a535b00d3dbcb"
export LIBMBEDTLS_VERSION="2.24.0"
export LIBMEDTLS_HASH="b5a779b5f36d5fc4cba55faa410685f89128702423ad07b36c5665441a06a5f3"
export LIBSRT_VERSION="1.4.2"
export LIBSRT_HASH="28a308e72dcbb50eb2f61b50cc4c393c413300333788f3a8159643536684a0c4"
export LIBTHEORA_VERSION="1.1.1"
export LIBTHEORA_HASH="b6ae1ee2fa3d42ac489287d3ec34c5885730b1296f0801ae577a35193d3affbc"
export FFMPEG_VERSION="4.3.1"
export FFMPEG_HASH="ad009240d46e307b4e03a213a0f49c11b650e445b1f8be0dda2a9212b34d2ffb"
export LIBLUAJIT_VERSION="2.1.0-beta3"
export LIBLUAJIT_HASH="1ad2e34b111c802f9d0cdf019e986909123237a28c746b21295b63c9e785d9c3"
export LIBFREETYPE_VERSION="2.10.4"
export LIBFREETYPE_HASH="86a854d8905b19698bbc8f23b860bc104246ce4854dcea8e3b0fb21284f75784"
export PCRE_VERSION="8.44"
export PCRE_HASH="19108658b23b3ec5058edc9f66ac545ea19f9537234be1ec62b714c84399366d"
export SWIG_VERSION="4.0.2"
export SWIG_HASH="d53be9730d8d58a16bf0cbd1f8ac0c0c3e1090573168bfa151b01eb47fa906fc"
export MACOSX_DEPLOYMENT_TARGET="10.13"
export PATH="/usr/local/opt/ccache/libexec:${PATH}"
export CURRENT_DATE="$(date +"%Y-%m-%d")"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/tmp/obsdeps/lib/pkgconfig"
export PARALLELISM="$(sysctl -n hw.ncpu)"
export FFMPEG_CHECKSUM="$FFMPEG_CHECKSUM"

hr() {
     echo -e "${COLOR_BLUE}[${PRODUCT_NAME}] ${1}${COLOR_RESET}"
}

step() {
    echo -e "${COLOR_GREEN}  + ${1}${COLOR_RESET}"
}

info() {
    echo -e "${COLOR_ORANGE}  + ${1}${COLOR_RESET}"
}

error() {
     echo -e "${COLOR_RED}  + ${1}${COLOR_RESET}"
}

exists() {
    command -v "${1}" >/dev/null 2>&1
}

ensure_dir() {
    [[ -n ${1} ]] && /bin/mkdir -p ${1} && builtin cd ${1}
}

cleanup() {
    restore_brews
}

mkdir() {
    /bin/mkdir -p $*
}

trap cleanup EXIT

caught_error() {
    error "ERROR during build step: ${1}"
    cleanup $${BASE_DIR}
    exit 1
}

restore_brews() {
    if [ -d /usr/local/opt/xz ] && [ ! -f /usr/local/lib/liblzma.dylib ]; then
      brew link xz
    fi

    if [ -d /usr/local/opt/zstd ] && [ ! -f /usr/local/lib/libzstd.dylib ]; then
      brew link zstd
    fi

    if [ -d /usr/local/opt/libtiff ] && [ !  -f /usr/local/lib/libtiff.dylib ]; then
      brew link libtiff
    fi

    if [ -d /usr/local/opt/webp ] && [ ! -f /usr/local/lib/libwebp.dylib ]; then
      brew link webp
    fi
}

build_ed174edc-ab61-465c-910b-2bd05906cd20() {
    step "Install Homebrew dependencies"
    trap "caught_error 'Install Homebrew dependencies'" ERR
    ensure_dir ${BASE_DIR}

    if [ -d /usr/local/opt/xz ]; then
      brew unlink xz
    fi
    if [ -d /usr/local/opt/openssl@1.0.2t ]; then
        brew uninstall openssl@1.0.2t
        brew untap local/openssl
    fi
    
    if [ -d /usr/local/opt/python@2.7.17 ]; then
        brew uninstall python@2.7.17
        brew untap local/python2
    fi
    brew bundle
}


build_890c5e1e-c32d-4051-ba13-bf240381e0b5() {
    step "Get Current Date"
    trap "caught_error 'Get Current Date'" ERR
    ensure_dir ${BASE_DIR}


}


build_458e84b8-c1a0-4709-8966-c312f225aab6() {
    step "Build environment setup"
    trap "caught_error 'Build environment setup'" ERR
    ensure_dir ${BASE_DIR}

    mkdir -p CI_BUILD/obsdeps/bin
    mkdir -p CI_BUILD/obsdeps/include
    mkdir -p CI_BUILD/obsdeps/lib
    mkdir -p CI_BUILD/obsdeps/share
    
    
    FFMPEG_CHECKSUM="$(echo "${FFMPEG_VERSION}-${LIBOGG_VERSION}-${LIBVORBIS_VERSION}-${LIBVPX_VERSION}-${LIBOPUS_VERSION}-${LIBX264_VERSION}-${LIBSRT_VERSION}-${LIBMBEDTLS_VERSION}-${LIBTHEORA_VERSION}" | sha256sum | cut -d " " -f 1)"
    
}


build_a84b19c9-4c15-409e-a042-986e1b3d9881() {
    step "Build dependency swig"
    trap "caught_error 'Build dependency swig'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD

    ${BASE_DIR}/utils/safe_fetch "https://downloads.sourceforge.net/project/swig/swig/swig-${SWIG_VERSION}/swig-${SWIG_VERSION}.tar.gz" "${SWIG_HASH}"
    tar -xf swig-${SWIG_VERSION}.tar.gz
    cd swig-${SWIG_VERSION}
    mkdir build
    cd build
    ${BASE_DIR}/utils/safe_fetch "https://ftp.pcre.org/pub/pcre/pcre-${PCRE_VERSION}.tar.bz2" "${PCRE_HASH}"
    ../Tools/pcre-build.sh
    ../configure --disable-dependency-tracking --prefix="/tmp/obsdeps"
    make -j${PARALLELISM}
}


build_15c11fdc-de82-43b2-9c02-faf7ab0af073() {
    step "Install dependency swig"
    trap "caught_error 'Install dependency swig'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD/swig-4.0.2/build

    cp swig ${BASE_DIR}/CI_BUILD/obsdeps/bin/
    mkdir -p ${BASE_DIR}/CI_BUILD/obsdeps/share/swig/${SWIG_VERSION}
    rsync -avh --include="*.i" --include="*.swg" --include="python" --include="lua" --include="typemaps" --exclude="*" ../Lib/* ${BASE_DIR}/CI_BUILD/obsdeps/share/swig/${SWIG_VERSION}
}


build_4a4bdf51-44ec-412a-b4bc-3464d350cad5() {
    step "Build dependency libpng"
    trap "caught_error 'Build dependency libpng'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD

    ${BASE_DIR}/utils/safe_fetch "https://downloads.sourceforge.net/project/libpng/libpng16/${LIBPNG_VERSION}/libpng-${LIBPNG_VERSION}.tar.xz" "${LIBPNG_HASH}"
    tar -xf libpng-${LIBPNG_VERSION}.tar.xz
    cd libpng-${LIBPNG_VERSION}
    mkdir build
    cd build
    ../configure --enable-static --disable-shared --prefix="/tmp/obsdeps"
    make -j${PARALLELISM}
}


build_5c1db530-a69b-45d1-bdbd-efe370c48b97() {
    step "Install dependency libpng"
    trap "caught_error 'Install dependency libpng'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD/libpng-1.6.37/build

    make install
}


build_b1cf2e3b-3ec0-4a65-8db0-712bb5f36235() {
    step "Build dependency libopus"
    trap "caught_error 'Build dependency libopus'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD

    ${BASE_DIR}/utils/safe_fetch "https://ftp.osuosl.org/pub/xiph/releases/opus/opus-${LIBOPUS_VERSION}.tar.gz" "${LIBOPUS_HASH}"
    tar -xf opus-${LIBOPUS_VERSION}.tar.gz
    cd ./opus-${LIBOPUS_VERSION}
    mkdir build
    cd ./build
    ../configure --disable-shared --enable-static --disable-doc --prefix="/tmp/obsdeps"
    make -j${PARALLELISM}
}


build_9bb119a2-1d87-4b6e-a718-6ebc1bb353a0() {
    step "Install dependency libopus"
    trap "caught_error 'Install dependency libopus'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD/opus-1.3.1/build

    make install
}


build_163ae8f3-be08-4a54-9392-0ddcfd8317cc() {
    step "Build dependency libogg"
    trap "caught_error 'Build dependency libogg'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD

    ${BASE_DIR}/utils/safe_fetch "https://downloads.xiph.org/releases/ogg/libogg-${LIBOGG_VERSION}.tar.gz" "${LIBOGG_HASH}"
    tar -xf libogg-${LIBOGG_VERSION}.tar.gz
    cd ./libogg-${LIBOGG_VERSION}
    ${BASE_DIR}/utils/apply_patch "https://github.com/xiph/ogg/commit/c8fca6b4a02d695b1ceea39b330d4406001c03ed.patch?full_index=1" "0f4d289aecb3d5f7329d51f1a72ab10c04c336b25481a40d6d841120721be485"
    mkdir build
    cd ./build
    ../configure --disable-shared --enable-static --prefix="/tmp/obsdeps"
    make -j${PARALLELISM}
}


build_85d49403-896a-40f7-89ac-bd1045fb5027() {
    step "Install dependency libogg"
    trap "caught_error 'Install dependency libogg'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD/libogg-1.3.4/build

    make install
}


build_eaca23f9-55fa-42ed-bf7a-c038b24334c5() {
    step "Build dependency libvorbis"
    trap "caught_error 'Build dependency libvorbis'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD

    ${BASE_DIR}/utils/safe_fetch "https://downloads.xiph.org/releases/vorbis/libvorbis-${LIBVORBIS_VERSION}.tar.xz" "${LIBVORBIS_HASH}"
    tar -xf libvorbis-${LIBVORBIS_VERSION}.tar.xz
    cd ./libvorbis-${LIBVORBIS_VERSION}
    mkdir build
    cd ./build
    ../configure --disable-shared --enable-static --prefix="/tmp/obsdeps"
    make -j${PARALLELISM}
}


build_f9a838ba-36e0-42bd-9b34-17a8453a566a() {
    step "Install dependency libvorbis"
    trap "caught_error 'Install dependency libvorbis'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD/libvorbis-1.3.7/build

    make install
}


build_24631f6e-cfd7-4f4a-a3ab-e2de2f6da256() {
    step "Build dependency libvpx"
    trap "caught_error 'Build dependency libvpx'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD

    ${BASE_DIR}/utils/safe_fetch "https://github.com/webmproject/libvpx/archive/v${LIBVPX_VERSION}.tar.gz" "${LIBVPX_HASH}"
    mkdir -p ./libvpx-v${LIBVPX_VERSION}
    tar -xf v${LIBVPX_VERSION}.tar.gz
    cd ./libvpx-${LIBVPX_VERSION}
    mkdir -p build
    cd ./build
    ../configure --disable-shared --disable-examples --disable-unit-tests --enable-pic --enable-vp9-highbitdepth --prefix="/tmp/obsdeps" --libdir="/tmp/obsdeps/lib"
    make -j${PARALLELISM}
}


build_d0d045f7-f573-4c91-98eb-20d4f888221e() {
    step "Install dependency libvpx"
    trap "caught_error 'Install dependency libvpx'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD/libvpx-1.9.0/build

    make install
}


build_b3a6b33a-7893-450a-9043-47d643b90342() {
    step "Build dependency libjansson"
    trap "caught_error 'Build dependency libjansson'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD

    ${BASE_DIR}/utils/safe_fetch "https://digip.org/jansson/releases/jansson-${LIBJANSSON_VERSION}.tar.gz" "${LIBJANSSON_HASH}"
    tar -xf jansson-${LIBJANSSON_VERSION}.tar.gz
    cd jansson-${LIBJANSSON_VERSION}
    mkdir build
    cd ./build
    ../configure --libdir="/tmp/obsdeps/bin" --enable-shared --disable-static
    make -j${PARALLELISM}
}


build_43959585-75fa-488a-ab1a-f60ade6b03ba() {
    step "Install dependency libjansson"
    trap "caught_error 'Install dependency libjansson'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD/jansson-2.13.1/build

    find . -name \*.dylib -exec cp -PR \{\} ${BASE_DIR}/CI_BUILD/obsdeps/bin/ \;
    rsync -avh --include="*/" --include="*.h" --exclude="*" ../src/* ${BASE_DIR}/CI_BUILD/obsdeps/include/
    rsync -avh --include="*/" --include="*.h" --exclude="*" ./src/* ${BASE_DIR}/CI_BUILD/obsdeps/include/
    cp ./*.h ${BASE_DIR}/CI_BUILD/obsdeps/include/
}


build_8d879ce6-afb1-4fc4-b869-f4b81db06cd7() {
    step "Build dependency libx264"
    trap "caught_error 'Build dependency libx264'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD

    CLANG_BUILD_VERSION="$(clang --version | sed -En 's/.+\clang-([0-9]+).+/\1/p')"
    if [ "${CLANG_BUILD_VERSION}" -ge 1010 ]; then
      CONFIG_EXTRA="-fno-stack-check"
    fi
    mkdir -p x264-${LIBX264_VERSION}
    cd ./x264-${LIBX264_VERSION}
    ${BASE_DIR}/utils/github_fetch mirror x264 "${LIBX264_HASH}"
    ${BASE_DIR}/utils/apply_patch "https://github.com/mirror/x264/commit/eb95c2965299ba5b8598e2388d71b02e23c9fba7.patch?full_index=1" "a7df326ced312c3aa2ae4c463ab08e43961b2dea63b7b365874fb0d59622e63d"
    mkdir build
    cd ./build
    ../configure --extra-ldflags="-mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}" ${CONFIG_EXTRA} --enable-static --disable-lsmash --disable-swscale --disable-ffms --enable-strip --prefix="/tmp/obsdeps"
    make -j${PARALLELISM}
}


build_69bec30c-194e-40cf-a66b-eacd757456fd() {
    step "Install dependency libx264"
    trap "caught_error 'Install dependency libx264'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD/x264-r3018/build

    make install
}


build_c034e411-2338-49be-b2fd-67084bcc4b55() {
    step "Build dependency libx264 (dylib)"
    trap "caught_error 'Build dependency libx264 (dylib)'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD/x264-r3018/build

    ../configure --extra-ldflags="-mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}" ${CONFIG_EXTRA} --enable-shared  --disable-lsmash --disable-swscale --disable-ffms --enable-strip --libdir="/tmp/obsdeps/bin" --prefix="/tmp/obsdeps"
    make -j${PARALLELISM}
}


build_fdbd4441-6a6b-4d9f-b953-17271997557e() {
    step "Install dependency libx264 (dylib)"
    trap "caught_error 'Install dependency libx264 (dylib)'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD/x264-r3018/build

    ln -f -s libx264.*.dylib libx264.dylib
    find . -name \*.dylib -exec cp -PR \{\} ${BASE_DIR}/CI_BUILD/obsdeps/bin/ \;
    rsync -avh --include="*/" --include="*.h" --exclude="*" ../* ${BASE_DIR}/CI_BUILD/obsdeps/include/
    rsync -avh --include="*/" --include="*.h" --exclude="*" ./* ${BASE_DIR}/CI_BUILD/obsdeps/include/
}


build_1f8c6383-2466-43a1-9f38-c53363138940() {
    step "Build dependency libmbedtls"
    trap "caught_error 'Build dependency libmbedtls'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD

    ${BASE_DIR}/utils/safe_fetch "https://github.com/ARMmbed/mbedtls/archive/mbedtls-${LIBMBEDTLS_VERSION}.tar.gz" "${LIBMEDTLS_HASH}"
    tar -xf mbedtls-${LIBMBEDTLS_VERSION}.tar.gz
    cd mbedtls-mbedtls-${LIBMBEDTLS_VERSION}
    sed -i '.orig' 's/\/\/\#define MBEDTLS_THREADING_PTHREAD/\#define MBEDTLS_THREADING_PTHREAD/g' include/mbedtls/config.h
    sed -i '.orig' 's/\/\/\#define MBEDTLS_THREADING_C/\#define MBEDTLS_THREADING_C/g' include/mbedtls/config.h
    mkdir build
    cd ./build
    cmake -DCMAKE_INSTALL_PREFIX="/tmp/obsdeps" -DUSE_SHARED_MBEDTLS_LIBRARY=ON -DENABLE_PROGRAMS=OFF ..
    make -j${PARALLELISM}
}


build_017d7372-8fe4-43e4-aec8-c5008eb353f6() {
    step "Install dependency libmbedtls"
    trap "caught_error 'Install dependency libmbedtls'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD/mbedtls-mbedtls-2.24.0/build

    make install
    install_name_tool -id /tmp/obsdeps/lib/libmbedtls.${LIBMBEDTLS_VERSION}.dylib /tmp/obsdeps/lib/libmbedtls.${LIBMBEDTLS_VERSION}.dylib
    install_name_tool -id /tmp/obsdeps/lib/libmbedcrypto.${LIBMBEDTLS_VERSION}.dylib /tmp/obsdeps/lib/libmbedcrypto.${LIBMBEDTLS_VERSION}.dylib
    install_name_tool -id /tmp/obsdeps/lib/libmbedx509.${LIBMBEDTLS_VERSION}.dylib /tmp/obsdeps/lib/libmbedx509.${LIBMBEDTLS_VERSION}.dylib
    install_name_tool -change libmbedx509.1.dylib /tmp/obsdeps/lib/libmbedx509.1.dylib /tmp/obsdeps/lib/libmbedtls.${LIBMBEDTLS_VERSION}.dylib
    install_name_tool -change libmbedcrypto.5.dylib /tmp/obsdeps/lib/libmbedcrypto.5.dylib /tmp/obsdeps/lib/libmbedtls.${LIBMBEDTLS_VERSION}.dylib
    install_name_tool -change libmbedcrypto.5.dylib /tmp/obsdeps/lib/libmbedcrypto.5.dylib /tmp/obsdeps/lib/libmbedx509.${LIBMBEDTLS_VERSION}.dylib
    find /tmp/obsdeps/lib -name libmbed\*.dylib -exec cp -PR \{\} ${BASE_DIR}/CI_BUILD/obsdeps/lib/ \;
    rsync -avh --include="*/" --include="*.h" --exclude="*" ./include/mbedtls/* ${BASE_DIR}/CI_BUILD/obsdeps/include/mbedtls
    rsync -avh --include="*/" --include="*.h" --exclude="*" ../include/mbedtls/* ${BASE_DIR}/CI_BUILD/obsdeps/include/mbedtls
    if [ ! -d /tmp/obsdeps/lib/pkgconfig ]; then
        mkdir -p /tmp/obsdeps/lib/pkgconfig
    fi
    cat <<EOF > /tmp/obsdeps/lib/pkgconfig/mbedcrypto.pc
prefix=/tmp/obsdeps
libdir=\${prefix}/lib
includedir=\${prefix}/include
 
Name: mbedcrypto
Description: lightweight crypto and SSL/TLS library.
Version: ${LIBMBEDTLS_VERSION}
 
Libs: -L\${libdir} -lmbedcrypto
Cflags: -I\${includedir}
 
EOF
    cat <<EOF > /tmp/obsdeps/lib/pkgconfig/mbedtls.pc
prefix=/tmp/obsdeps
libdir=\${prefix}/lib
includedir=\${prefix}/include
 
Name: mbedtls
Description: lightweight crypto and SSL/TLS library.
Version: ${LIBMBEDTLS_VERSION}
 
Libs: -L\${libdir} -lmbedtls
Cflags: -I\${includedir}
Requires.private: mbedx509
 
EOF
    cat <<EOF > /tmp/obsdeps/lib/pkgconfig/mbedx509.pc
prefix=/tmp/obsdeps
libdir=\${prefix}/lib
includedir=\${prefix}/include
 
Name: mbedx509
Description: The mbedTLS X.509 library
Version: ${LIBMBEDTLS_VERSION}
 
Libs: -L\${libdir} -lmbedx509
Cflags: -I\${includedir}
Requires.private: mbedcrypto
 
EOF
}


build_7c419fd7-d06b-4b3e-84bd-c4f0354c08bc() {
    step "Build dependency libsrt"
    trap "caught_error 'Build dependency libsrt'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD

    ${BASE_DIR}/utils/safe_fetch "https://github.com/Haivision/srt/archive/v${LIBSRT_VERSION}.tar.gz" "${LIBSRT_HASH}"
    tar -xf v${LIBSRT_VERSION}.tar.gz
    cd srt-${LIBSRT_VERSION}
    mkdir build
    cd ./build
    cmake -DCMAKE_INSTALL_PREFIX="/tmp/obsdeps" -DENABLE_APPS=OFF -DUSE_ENCLIB="mbedtls" -DENABLE_STATIC=ON -DENABLE_SHARED=OFF -DSSL_INCLUDE_DIRS="/tmp/obsdeps/include" -DSSL_LIBRARY_DIRS="/tmp/obsdeps/lib" -DCMAKE_FIND_FRAMEWORK=LAST ..
    make -j${PARALLELISM}
}


build_3c76cefb-c241-447f-b348-8461ec09f271() {
    step "Install dependency libsrt"
    trap "caught_error 'Install dependency libsrt'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD/srt-1.4.2/build

    make install
}


build_59b27ab6-8f3a-440b-b94c-ae8c05d89ef6() {
    step "Build dependency libtheora"
    trap "caught_error 'Build dependency libtheora'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD

    ${BASE_DIR}/utils/safe_fetch "https://downloads.xiph.org/releases/theora/libtheora-${LIBTHEORA_VERSION}.tar.bz2" "${LIBTHEORA_HASH}"
    tar -xf libtheora-${LIBTHEORA_VERSION}.tar.bz2
    cd libtheora-${LIBTHEORA_VERSION}
    mkdir build
    cd ./build
    ../configure --disable-shared --enable-static --disable-oggtest --disable-vorbistest --disable-examples --prefix="/tmp/obsdeps"
    make -j${PARALLELISM}
}


build_a36c85ad-fab1-4cd7-8bbb-9822946068c5() {
    step "Install dependency libtheora"
    trap "caught_error 'Install dependency libtheora'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD/libtheora-1.1.1/build

    make install
}


build_0d667319-96d3-40f7-86a3-c00490370af5() {
    step "Build dependency ffmpeg"
    trap "caught_error 'Build dependency ffmpeg'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD

    export LDFLAGS="-L/tmp/obsdeps/lib"
    export CFLAGS="-I/tmp/obsdeps/include"
    export LD_LIBRARY_PATH="/tmp/obsdeps/lib"
    ${BASE_DIR}/utils/safe_fetch "https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.xz" "${FFMPEG_HASH}"
    tar -xf ffmpeg-${FFMPEG_VERSION}.tar.xz
    cd ./ffmpeg-${FFMPEG_VERSION}
    ${BASE_DIR}/utils/apply_patch "https://github.com/FFmpeg/FFmpeg/commit/7c59e1b0f285cd7c7b35fcd71f49c5fd52cf9315.patch?full_index=1" "1cbe1b68d70eadd49080a6e512a35f3e230de26b6e1b1c859d9119906417737f"
    mkdir build
    cd ./build
    ../configure --host-cflags="-I/tmp/obsdeps/include" --host-ldflags="-L/tmp/obsdeps/lib" --pkg-config-flags="--static" --extra-ldflags="-mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}" --enable-shared --disable-static --enable-pthreads --enable-version3 --shlibdir="/tmp/obsdeps/bin" --enable-gpl --enable-videotoolbox --disable-libjack --disable-indev=jack --disable-outdev=sdl --disable-programs --disable-doc --enable-libx264 --enable-libopus --enable-libvorbis --enable-libvpx --enable-libsrt --enable-libtheora
    make -j${PARALLELISM}
}


build_3df330aa-6060-4115-ac84-bda230f9cf55() {
    step "Install dependency ffmpeg"
    trap "caught_error 'Install dependency ffmpeg'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD/ffmpeg-4.3.1/build

    find . -name \*.dylib -exec cp -PR \{\} ${BASE_DIR}/CI_BUILD/obsdeps/bin/ \;
    rsync -avh --include="*/" --include="*.h" --exclude="*" ../* ${BASE_DIR}/CI_BUILD/obsdeps/include/
    rsync -avh --include="*/" --include="*.h" --exclude="*" ./* ${BASE_DIR}/CI_BUILD/obsdeps/include/
}


build_8c22d85a-0d5e-4140-a550-04dd8ff3b8ef() {
    step "Build dependency libluajit"
    trap "caught_error 'Build dependency libluajit'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD

    ${BASE_DIR}/utils/safe_fetch "https://luajit.org/download/LuaJIT-${LIBLUAJIT_VERSION}.tar.gz" "${LIBLUAJIT_HASH}"
    tar -xf LuaJIT-${LIBLUAJIT_VERSION}.tar.gz
    cd LuaJIT-${LIBLUAJIT_VERSION}
    make PREFIX="/tmp/obsdeps" -j${PARALLELISM}
}


build_f46cfd0b-b35c-4538-9da7-d0d9a5115f2e() {
    step "Install dependency libluajit"
    trap "caught_error 'Install dependency libluajit'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD/LuaJIT-2.1.0-beta3

    make PREFIX="/tmp/obsdeps" install
    find /tmp/obsdeps/lib -name libluajit\*.dylib -exec cp -PR \{\} ${BASE_DIR}/CI_BUILD/obsdeps/lib/ \;
    rsync -avh --include="*/" --include="*.h" --exclude="*" src/* ${BASE_DIR}/CI_BUILD/obsdeps/include/
    make PREFIX="/tmp/obsdeps" uninstall
}


build_1180debf-c3be-4679-8445-7903e0bbb8a1() {
    step "Build dependency libfreetype"
    trap "caught_error 'Build dependency libfreetype'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD

    export CFLAGS="-mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}"
    ${BASE_DIR}/utils/safe_fetch "https://downloads.sourceforge.net/project/freetype/freetype2/${LIBFREETYPE_VERSION}/freetype-${LIBFREETYPE_VERSION}.tar.xz" "${LIBFREETYPE_HASH}"
    tar -xf freetype-${LIBFREETYPE_VERSION}.tar.xz
    cd freetype-${LIBFREETYPE_VERSION}
    mkdir build
    cd build
    ../configure --enable-shared --disable-static --prefix="/tmp/obsdeps" --without-harfbuzz
    make -j${PARALLELISM}
}


build_0cb6328d-5efe-41f6-a0f4-767938ec58b0() {
    step "Install dependency libfreetype"
    trap "caught_error 'Install dependency libfreetype'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD/freetype-2.10.4/build

    make install
    find /tmp/obsdeps/lib -name libfreetype\*.dylib -exec cp -PR \{\} ${BASE_DIR}/CI_BUILD/obsdeps/lib/ \;
    rsync -avh --include="*/" --include="*.h" --exclude="*" ../include/* ${BASE_DIR}/CI_BUILD/obsdeps/include/
}


build_5f1ed01d-dc1c-4f2f-8180-62fd13a01a47() {
    step "Build dependency librnnoise"
    trap "caught_error 'Build dependency librnnoise'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD

    mkdir -p rnnoise-${LIBRNNOISE_VERSION}
    cd ./rnnoise-${LIBRNNOISE_VERSION}
    ${BASE_DIR}/utils/github_fetch xiph rnnoise "${LIBRNNOISE_HASH}"
    ./autogen.sh
    mkdir build
    cd build
    ../configure --prefix="/tmp/obsdeps"
    make -j${PARALLELISM}
}


build_971801cd-b634-48b4-8ccc-cd9fa70c5c5d() {
    step "Install dependency librnnoise"
    trap "caught_error 'Install dependency librnnoise'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD/rnnoise-2020-07-28/build

    make install
    find /tmp/obsdeps/lib -name librnnoise\*.dylib -exec cp -PR \{\} ${BASE_DIR}/CI_BUILD/obsdeps/lib/ \;
    rsync -avh --include="*/" --include="*.h" --exclude="*" ../include/* ${BASE_DIR}/CI_BUILD/obsdeps/include/
}


build_0b2ed5f3-5622-4582-b95f-b0d1fdd71b25() {
    step "Package dependencies"
    trap "caught_error 'Package dependencies'" ERR
    ensure_dir ${BASE_DIR}/CI_BUILD

    tar -czf macos-deps-${CURRENT_DATE}.tar.gz obsdeps
    if [ ! -d "${BASE_DIR}/macos" ]; then
      mkdir ${BASE_DIR}/macos
    fi
    mv ./macos-deps-${CURRENT_DATE}.tar.gz ${BASE_DIR}/macos
}


obs-deps-build-main() {
    ensure_dir ${BASE_DIR}

    build_ed174edc-ab61-465c-910b-2bd05906cd20
    build_890c5e1e-c32d-4051-ba13-bf240381e0b5
    build_458e84b8-c1a0-4709-8966-c312f225aab6
    build_a84b19c9-4c15-409e-a042-986e1b3d9881
    build_15c11fdc-de82-43b2-9c02-faf7ab0af073
    build_4a4bdf51-44ec-412a-b4bc-3464d350cad5
    build_5c1db530-a69b-45d1-bdbd-efe370c48b97
    build_b1cf2e3b-3ec0-4a65-8db0-712bb5f36235
    build_9bb119a2-1d87-4b6e-a718-6ebc1bb353a0
    build_163ae8f3-be08-4a54-9392-0ddcfd8317cc
    build_85d49403-896a-40f7-89ac-bd1045fb5027
    build_eaca23f9-55fa-42ed-bf7a-c038b24334c5
    build_f9a838ba-36e0-42bd-9b34-17a8453a566a
    build_24631f6e-cfd7-4f4a-a3ab-e2de2f6da256
    build_d0d045f7-f573-4c91-98eb-20d4f888221e
    build_b3a6b33a-7893-450a-9043-47d643b90342
    build_43959585-75fa-488a-ab1a-f60ade6b03ba
    build_8d879ce6-afb1-4fc4-b869-f4b81db06cd7
    build_69bec30c-194e-40cf-a66b-eacd757456fd
    build_c034e411-2338-49be-b2fd-67084bcc4b55
    build_fdbd4441-6a6b-4d9f-b953-17271997557e
    build_1f8c6383-2466-43a1-9f38-c53363138940
    build_017d7372-8fe4-43e4-aec8-c5008eb353f6
    build_7c419fd7-d06b-4b3e-84bd-c4f0354c08bc
    build_3c76cefb-c241-447f-b348-8461ec09f271
    build_59b27ab6-8f3a-440b-b94c-ae8c05d89ef6
    build_a36c85ad-fab1-4cd7-8bbb-9822946068c5
    build_0d667319-96d3-40f7-86a3-c00490370af5
    build_3df330aa-6060-4115-ac84-bda230f9cf55
    build_8c22d85a-0d5e-4140-a550-04dd8ff3b8ef
    build_f46cfd0b-b35c-4538-9da7-d0d9a5115f2e
    build_1180debf-c3be-4679-8445-7903e0bbb8a1
    build_0cb6328d-5efe-41f6-a0f4-767938ec58b0
    build_5f1ed01d-dc1c-4f2f-8180-62fd13a01a47
    build_971801cd-b634-48b4-8ccc-cd9fa70c5c5d
    build_0b2ed5f3-5622-4582-b95f-b0d1fdd71b25

    restore_brews

    hr "All Done"
}

obs-deps-build-main $*