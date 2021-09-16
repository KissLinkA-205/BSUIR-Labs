#pragma once
#include "libraries.h"

class PciDevicesData
{
private:
	HDEVINFO devInfo; //���������� ������ ���������� �� �����������
	SP_DEVINFO_DATA devData; //��������� ������������ ���������� �� ����������

public:
	PciDevicesData();
	~PciDevicesData();

	bool bind(DWORD index);
	std::wstring getName();
	std::wstring getVendorID();
	std::wstring getDeviceID();
};

