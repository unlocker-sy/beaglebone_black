# beaglebone_black
--------------------------------------------------------------------------------
시리얼 포트도 별도로 지원되고, 업그레이드도 라즈베리파이에 비해 편하다.  
꼭 무언가를 구현하지 않아도 u-boot, kernel 코드를 분석해보려고 한다.


## wiki
--------------------------------------------------------------------------------
### sdk download
sdk를 다운로드/설치하는 방법은 2가지가 있다.
yocto sdk를 다운 받아서 빌드하는 방법 과 이미 build된 sdk를 사용하는 방법
 - SDK코드 다운로드, 문서  
https://www.ti.com/tool/download/PROCESSOR-SDK-LINUX-AM335X
  
 - 아래 페이지의 실행파일로 설치하면, yocto build 필요없이 make만으로 전체 빌드가 가능하다.  
https://software-dl.ti.com/processor-sdk-linux/esd/docs/07_03_00_005/linux/Overview/Download_and_Install_the_SDK.html
    
  
### build
https://software-dl.ti.com/processor-sdk-linux/esd/docs/latest/linux/Overview_Building_the_SDK.html#overview-building-the-sdk
  
default image로 빌드했다.  
bitbake 중간에 에러가 발생한다.  
git 버전, ubuntu 버전이 달라서 지원이 되지 않는 부분이 있다.  
수정 내용은 별도의 문서에 업데이트 할 예정임..  
    
  
### linux sdk 관련 대주제
https://software-dl.ti.com/processor-sdk-linux/esd/docs/latest/devices/AM335X/linux/index.html
  
### How_to_Guides 전체 목차
https://software-dl.ti.com/processor-sdk-linux/esd/docs/latest/linux/How_to_Guides.html
  
### Program_the_eMMC_on_Beaglebone_Black
https://software-dl.ti.com/processor-sdk-linux/esd/docs/latest/linux/How_to_Guides/Host/Program_the_eMMC_on_Beaglebone_Black.html
  
### Flashing eMMC on BeagleBone Black via SD Card
https://software-dl.ti.com/processor-sdk-linux/esd/docs/latest/linux/How_to_Guides/Target/How_to_Program_Beaglebone_Black_eMMC_via_SD_Card.html
  
  
  
## BEAGL-BONE-BLACK관련 TI 지원 페이지
------------------------------------------------------------------------------------
https://www.ti.com/tool/BEAGL-BONE-BLACK?keyMatch=BEAGLEBONE%20BLACK#order-start-development
  
### BeagleBone Black 가이드 문서
https://github.com/beagleboard/beaglebone-black/wiki/System-Reference-Manual
  
user guide참고  
power(PMIC), reset, memory, power rail, emmc, ethernet, hdmi, usb host, pru core, usb client등  
전반적인 내용들에 대해 설명이 잘 되어 있는 편이다.  
