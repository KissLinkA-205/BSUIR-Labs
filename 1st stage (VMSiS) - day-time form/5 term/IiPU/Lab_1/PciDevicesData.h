#pragma once
#include "libraries.h"

class PciDevicesData
{
private:
	HDEVINFO devInfo; //дескриптор набора информации об устройствах
	SP_DEVINFO_DATA devData; //структура представляет информацию об устройстве

public:
	PciDevicesData();
	~PciDevicesData();

	bool bind(DWORD index);
	std::wstring getName();
	std::wstring getVendorID();
	std::wstring getDeviceID();
};

