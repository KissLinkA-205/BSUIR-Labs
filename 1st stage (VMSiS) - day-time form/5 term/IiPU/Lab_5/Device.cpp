#include "device.h"

Device::Device(const Device& that)
{
	this->HARDWARE_ID = that.HARDWARE_ID;
	this->name = that.name;
	this->pid = that.pid;
	this->ejectable = that.ejectable;
	this->devInst = that.devInst;
	this->devicePath = that.devicePath;
	this->notificationHandle = that.notificationHandle;
}

void Device::unregister() const
{
	UnregisterDeviceNotification(notificationHandle);
}

bool Device::operator==(const Device& other) const {
	return this->pid == other.pid;
}

bool Device::isEjectable() const { 
	return this->ejectable; 
}

std::wstring Device::getName() const { 
	return name; 
};

void Device::remove(const Device& device)
{
	for (size_t i = 0; i < devices.size(); i++)
		if (device == devices[i])
		{
			devices[i].unregister();
			devices.erase(devices.begin() + i);
			break;
		}
}

void Device::register_handle(HWND hWnd)
{
	DEV_BROADCAST_HANDLE filter = { 0 };

	HANDLE deviceHandle = CreateFile(devicePath.c_str(), 0, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
	filter.dbch_size = sizeof(filter);
	filter.dbch_devicetype = DBT_DEVTYP_HANDLE;
	filter.dbch_handle = deviceHandle;
	this->notificationHandle = RegisterDeviceNotification(hWnd, &filter, DEVICE_NOTIFY_WINDOW_HANDLE);
	CloseHandle(deviceHandle);
}

Device::Device(PDEV_BROADCAST_DEVICEINTERFACE info, HWND hWnd)
{
	HDEVINFO deviceList = SetupDiCreateDeviceInfoList(nullptr, nullptr);
	SetupDiOpenDeviceInterfaceW(deviceList, (LPCWSTR)info->dbcc_name, NULL, NULL);

	SP_DEVINFO_DATA deviceInfo;
	ZeroMemory(&deviceInfo, sizeof(SP_DEVINFO_DATA));
	deviceInfo.cbSize = sizeof(SP_DEVINFO_DATA);
	SetupDiEnumDeviceInfo(deviceList, 0, &deviceInfo);

	*this = Device(deviceList, deviceInfo, hWnd);
}

Device::Device(HDEVINFO deviceList, SP_DEVINFO_DATA deviceInfo, HWND hWnd)
{
	this->devInst = deviceInfo.DevInst;
	TCHAR buffer[1024];
	ZeroMemory(buffer, sizeof(buffer));
	SetupDiGetDeviceRegistryProperty(deviceList, &deviceInfo, SPDRP_DEVICEDESC, NULL, (BYTE*)buffer, 1024, NULL);
	this->name = std::wstring(buffer);
	ZeroMemory(buffer, sizeof(buffer));
	SetupDiGetDeviceRegistryProperty(deviceList, &deviceInfo, SPDRP_HARDWAREID, nullptr, (BYTE*)buffer, 1024, nullptr);
	this->HARDWARE_ID = std::wstring(buffer);
	if (!this->HARDWARE_ID.empty() && (HARDWARE_ID.find(L"PID_") != -1))
		this->pid = HARDWARE_ID.substr(HARDWARE_ID.find(L"PID_") + 4, 4);

	DWORD properties;
	SetupDiGetDeviceRegistryPropertyA(deviceList, &deviceInfo, SPDRP_CAPABILITIES, NULL, (PBYTE)&properties, sizeof(DWORD), NULL);
	this->ejectable = properties & CM_DEVCAP_REMOVABLE;

	if (hWnd != nullptr && this->ejectable) {
		SP_DEVICE_INTERFACE_DATA devInterfaceData;
		SP_DEVICE_INTERFACE_DETAIL_DATA* devInterfaceDetailData;
		devInterfaceData.cbSize = sizeof(devInterfaceData);
		SetupDiEnumDeviceInterfaces(deviceList, &deviceInfo, &GUID_DEVINTERFACE_USB_DEVICE, 0, &devInterfaceData);

		DWORD requiredLength;
		SetupDiGetDeviceInterfaceDetail(deviceList, &devInterfaceData, NULL, 0, &requiredLength, NULL);

		devInterfaceDetailData = (PSP_INTERFACE_DEVICE_DETAIL_DATA)malloc(requiredLength);
		devInterfaceDetailData->cbSize = sizeof(SP_INTERFACE_DEVICE_DETAIL_DATA);
		SetupDiGetDeviceInterfaceDetail(deviceList, &devInterfaceData, devInterfaceDetailData, requiredLength, NULL, &deviceInfo);

		devicePath = std::wstring(devInterfaceDetailData->DevicePath);

		this->register_handle(hWnd);
	}

}

void Device::eject() const
{
	CM_Request_Device_EjectW(this->devInst, nullptr, nullptr, NULL, NULL);
}

void Device::print() const
{
	std::wcout << name << ", ";
	std::wcout << pid;
}