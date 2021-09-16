#include "PciDevicesData.h"

PciDevicesData::PciDevicesData() {
	devInfo = SetupDiGetClassDevs(
		nullptr, //указатель класса настройки устройства (необ¤зательно)
		TEXT("PCI"), //Enumerator - идентификатор экземпл¤ра устройства
		nullptr, //hwndParent - окно верхнего уровн¤ экземпл¤ра пользовательского интерфейса (необ¤зательно)
		DIGCF_PRESENT | DIGCF_ALLCLASSES); //Flags - устройва доступные в данный момент | все установленные
}

PciDevicesData::~PciDevicesData() {
	SetupDiDestroyDeviceInfoList(devInfo);
}

bool PciDevicesData::bind(DWORD index) {
	devData.cbSize = sizeof(SP_DEVINFO_DATA);
	return SetupDiEnumDeviceInfo(devInfo, index, &devData);
}

std::wstring PciDevicesData::getName() {
	TCHAR buffer[1024];
	SetupDiGetDeviceRegistryPropertyW(devInfo, //набор устройств
		&devData, //конкретное устройство из набора
		SPDRP_DEVICEDESC, //Property - получить название устойства
		nullptr, //получаемый тип данных
		(BYTE*)buffer, //куда записать им¤
		1024, //размер буфера
		nullptr); //сколько символов занимает идендификатор
	return std::wstring{ buffer };
}

std::wstring PciDevicesData::getDeviceID() {
	TCHAR buffer[1024];
	SetupDiGetDeviceRegistryPropertyW(devInfo, &devData, SPDRP_HARDWAREID, nullptr, (BYTE*)buffer, 1024, nullptr);
	return std::wstring{ buffer }.substr(std::wstring{ buffer }.find(L"DEV_") + 4, 4);
}

std::wstring PciDevicesData::getVendorID() {
	TCHAR buffer[1024];
	SetupDiGetDeviceRegistryPropertyW(devInfo, &devData, SPDRP_HARDWAREID, nullptr, (BYTE*)buffer, 1024, nullptr);
	return std::wstring{ buffer }.substr(std::wstring{ buffer }.find(L"VEN_") + 4, 4);
}