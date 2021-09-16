#include "PciDevicesData.h"

PciDevicesData::PciDevicesData() {
	devInfo = SetupDiGetClassDevs(
		nullptr, //��������� ������ ��������� ���������� (�������������)
		TEXT("PCI"), //Enumerator - ������������� ���������� ����������
		nullptr, //hwndParent - ���� �������� ������ ���������� ����������������� ���������� (�������������)
		DIGCF_PRESENT | DIGCF_ALLCLASSES); //Flags - �������� ��������� � ������ ������ | ��� �������������
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
	SetupDiGetDeviceRegistryPropertyW(devInfo, //����� ���������
		&devData, //���������� ���������� �� ������
		SPDRP_DEVICEDESC, //Property - �������� �������� ���������
		nullptr, //���������� ��� ������
		(BYTE*)buffer, //���� �������� ���
		1024, //������ ������
		nullptr); //������� �������� �������� �������������
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