#include "Battery.h"

Battery::Battery() {
	SYSTEM_POWER_STATUS status;
	GetSystemPowerStatus(&status);
	this->powerSupply = getPowerSupply(status);
	this->percent = status.BatteryLifePercent;
	this->lifeTime = status.BatteryLifeTime;
	this->stateCharge = getStateCharge(status);
	this->savingMode = getSavingMode(status);
}

string Battery::getPowerSupply(SYSTEM_POWER_STATUS status) {
	if (status.ACLineStatus == 1) {
		return "mains";
	}
	else if (status.ACLineStatus == 0) {
		return "battery";
	}
	else {
		return "unknown";
	}
}

string Battery::getStateCharge(SYSTEM_POWER_STATUS status) {
	switch (status.BatteryFlag) {
	case 0:
		return "not charging";
	case 1:
		return "high ( > 66% )";
	case 2:
		return "low ( > 20% )";
	case 4:
		return "critical ( < 5% )";
	case 8:
		return "charging";
	case 128:
		return "No system battery";
	default:
		return "unknown";
	}
}

string Battery::getSavingMode(SYSTEM_POWER_STATUS status) {
	if (status.SystemStatusFlag) {
		return "on";
	}
	return "off";
}

void Battery::printBatteryChemistry() {
	HDEVINFO DeviceInfoSet;
	DeviceInfoSet = SetupDiGetClassDevs(&GUID_DEVCLASS_BATTERY, NULL, NULL, DIGCF_PRESENT | DIGCF_DEVICEINTERFACE);
	
	SP_DEVICE_INTERFACE_DATA DeviceInterfaceData = { 0 };
	ZeroMemory(&DeviceInterfaceData, sizeof(SP_DEVINFO_DATA));
	DeviceInterfaceData.cbSize = sizeof(SP_DEVINFO_DATA);

	SetupDiEnumDeviceInterfaces(DeviceInfoSet, NULL, &GUID_DEVCLASS_BATTERY, 0, &DeviceInterfaceData);
	DWORD cbRequired = 0;

	SetupDiGetDeviceInterfaceDetail(DeviceInfoSet, &DeviceInterfaceData, NULL, NULL, &cbRequired, NULL);
	PSP_DEVICE_INTERFACE_DETAIL_DATA pdidd = (PSP_DEVICE_INTERFACE_DETAIL_DATA)LocalAlloc(LPTR, cbRequired);
	pdidd->cbSize = sizeof(*pdidd);

	SetupDiGetDeviceInterfaceDetail(DeviceInfoSet, &DeviceInterfaceData, pdidd, cbRequired, &cbRequired, NULL);		
	HANDLE hBattery = CreateFile(pdidd->DevicePath, GENERIC_READ | GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
	
	BATTERY_QUERY_INFORMATION BatteryQueryInformation = { 0 };
	DWORD bytesWait = 0;
	DWORD bytesReturned = 0;
	DeviceIoControl(hBattery, IOCTL_BATTERY_QUERY_TAG, &bytesWait, sizeof(bytesWait), &BatteryQueryInformation.BatteryTag,
		sizeof(BatteryQueryInformation.BatteryTag), &bytesReturned, NULL) && BatteryQueryInformation.BatteryTag;
		
	BATTERY_INFORMATION BatteryInfo = { 0 };
	BatteryQueryInformation.InformationLevel = BatteryInformation;

	DeviceIoControl(hBattery, IOCTL_BATTERY_QUERY_INFORMATION, &BatteryQueryInformation, sizeof(BatteryQueryInformation),
		&BatteryInfo, sizeof(BatteryInfo), &bytesReturned, NULL);

	for (int b = 0; b < 4; b++)
	{
		cout << BatteryInfo.Chemistry[b];		
	};

	LocalFree(pdidd);
	SetupDiDestroyDeviceInfoList(DeviceInfoSet);
}

ostream& operator<<(ostream& out, Battery battery)
{
	out << "BATTERY" << endl
		<< "  Power supply: " << battery.powerSupply << endl
		<< "  State of charge: " << battery.stateCharge << endl
		<< "  Percentage: " << battery.percent << "%" << endl
		<< "  Saving mode: " << battery.savingMode << endl
		<< "  Life time: " << battery.lifeTime << "s" << endl
		<< "  Chemistry: ";
	    battery.printBatteryChemistry();
		out << endl;
		
	return out;
}
