## sdk 다운로드
아래 url에서 LINUX SDK를 선택  
https://www.ti.com/tool/PROCESSOR-SDK-AM335X?keyMatch=AM335X#downloads

## 빌드
https://software-dl.ti.com/processor-sdk-linux/esd/docs/07_03_00_005/linux/Overview_Building_the_SDK.html
  
### oelayer setup
다시 oe-layertool-setup 스크립트 실행.
./oe-layertool-setup.sh -f configs/processor-sdk/processor-sdk-<version>-config.txt  
~~~

./oe-layertool-setup.sh -f configs/coresdk/coresdk-07.03.00.005-config.txt
~~~
  
~~~
################################################################################
A setenv file has been created for you in the conf directory.  Please verify
The contents of this file.  Once you have verified the contents please source
this file to configure your environment for building:

    . conf/setenv

You can then start building using the bitbake command.  You will likely want
to set the MACHINE option if you have not done so in your local.conf file.

For example:
    MACHINE=xxxxx bitbake <target>

Common targets are:
    core-image-minimal
    core-image-sato
    meta-toolchain
    meta-toolchain-sdk
    adt-installer
    meta-ide-support
~~~
  

### 환경변수 설정
~~~
$ cd build
$ . conf/setenv

export TOOLCHAIN_PATH_ARMV7=/home/sy/gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf
export TOOLCHAIN_PATH_ARMV8=/home/sy/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu

MACHINE=am335x-evm bitbake arago-core-tisdk-bundle
MACHINE=am335x-evm bitbake tisdk-base-image
~~~  
  
  
### bitbake를 하면 아래처럼 에러로그가 출력된다.
~~~
sy@ubuntu:~/Work/bbb/tisdk/build$ MACHINE=am335x-evm bitbake tisdk-base-image
NOTE: Your conf/bblayers.conf has been automatically updated.
NOTE: Your conf/bblayers.conf has been automatically updated.
NOTE: Started PRServer with DBfile: /home/sy/Work/bbb/tisdk/build/cache/prserv.sqlite3, IP: 127.0.0.1, PORT: 44315, PID: 77678
ERROR:  OE-core's config sanity checker detected a potential misconfiguration.
    Either fix the cause of this error or at your own risk disable the checker (see sanity.conf).
    Following is the list of potential problems / advisories:

    Your Python 3 is not a full install. Please install the module distutils.sysconfig (see the Getting Started guide for further information).
~~~
python3를 설치해주면 된다. --> docker파일에 추가
  
  
### conf/sanity.conf파일 추가
yocto build는 사용자 계정으로 실행되어야하는데 docker로 실행하면 root로 실행되기 때문에 error가 발생한다.  
아래 url을 보면 conf/sanity.conf를 추가하면 된다고 한다.
https://tutorialadda.com/blog/oe-core-s-config-sanity-checker-error-in-yocto-project
sy@ubuntu:~/Work/bbb/tisdk/build$ touch conf/sanity.conf

https://software-dl.ti.com/processor-sdk-linux/esd/docs/07_03_00_005/linux/Overview_Building_the_SDK.html


## long build.. build error 발생
do_fetch 중에 error가 발생한다.  
몇몇 package의 경우 repository url이 발생해서 그렇다.    
관련 error수정은 tisdk_yocto_build_error.md를 참고  
  
  
  
## arago sdk(하지 않는 것이 좋다.. 참고만..)
$ git clone git://arago-project.org/git/projects/oe-layersetup.git tisdk
$ cd tisdk
$ ./oe-layertool-setup.sh -f configs/processor-sdk/processor-sdk-<version>-config.txt
$ mkdir downloads
$ cd downloads

https://www.ti.com/tool/PROCESSOR-SDK-AM335X?keyMatch=AM335X#downloads
am335x-evm-linux-sdk-arago-src-07.03.00.005.tar.xz  — 5 K, AM335x Linux SDK Arago source downloads

$ git clone git://arago-project.org/git/projects/oe-layersetup.git tisdk
$ cd tisdk
$ ./oe-layertool-setup.sh -f configs/processor-sdk/processor-sdk-<version>-config.txt
$ mkdir downloads
$ cd downloads
$ # Assuming src file downloaded to $HOME/Downloads
$ tar xvf $HOME/Downloads/<target-board>-linux-sdk-arago-src-##.##.##.##.tar.xz
$ <target-board>-linux-sdk-arago-src-##.##.##.##/get_build_sources.sh <target-board>-linux-sdk-arago-src-##.##.##.##/source_pkg_list.txt
$ cd ..</span>
$ cd build
$ . conf/setenv
$ export TOOLCHAIN_PATH_ARMV7=$HOME/gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf
$ export TOOLCHAIN_PATH_ARMV8=$HOME/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu
$ MACHINE=am335x-evm bitbake arago-core-tisdk-bundle
error난다. arago-core-tisdk-bundle레시피 이름이 변경되어서 그렇다.
find . -name *.bb |grep arago
find . -name *.bb |grep bun
sy@ubuntu:~/Work/bbb/tisdk$ find . -name *.bb |grep bundle
./sources/meta-arago/meta-arago-distro/recipes-core/images/tisdk-core-bundle.bb
recipe이름이 tisdk-core-bundle로 바뀐듯하다.
아래 명령으로 bitbake하면 된다.
sy@ubuntu:~/Work/bbb/tisdk/build$ MACHINE=am335x-evm bitbake tisdk-core-bundle
sy@ubuntu:~/Work/am335x/sdk/tisdk/build$ MACHINE=am335x-evm bitbake tisdk-core-bundle
~~~
NOTE: Bitbake server didn't start within 5 seconds, waiting for 90
NOTE: Your conf/bblayers.conf has been automatically updated.
NOTE: Your conf/bblayers.conf has been automatically updated.
ERROR:  OE-core's config sanity checker detected a potential misconfiguration.
    Either fix the cause of this error or at your own risk disable the checker (see sanity.conf).
    Following is the list of potential problems / advisories:

    Your Python 3 is not a full install. Please install the module distutils.sysconfig (see the Getting Started guide for further information).
~~~
sy@ubuntu:~/Work/am335x/sdk/tisdk/build$ touch conf/sanity.conf
sy@ubuntu:~/Work/am335x/sdk/tisdk/build$ MACHINE=am335x-evm bitbake tisdk-core-bundle
