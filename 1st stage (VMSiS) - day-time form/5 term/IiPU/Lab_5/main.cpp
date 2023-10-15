#include "device.h"
#include <conio.h>
#include <initguid.h>
#include <Usbiodef.h>

std::vector<Device> Device::devices;
bool exitFlag = false;

void printMenu() {
	std::cout << "====================================================== Control: =======================================================" << std::endl;
	std::cout << "\t> Press \"e\" to exit" << std::endl;
	std::cout << "\t> Enter the number of the device to safely remove it" << std::endl;
	std::cout << "=======================================================================================================================" << std::endl << std::endl;
	std::cout << "\tThe list of connected USB devices:" << std::endl << std::endl;
}
void printDevices()
{
	for (int i = 0; i < Device::devices.size(); i++)
	{
		std::cout << i + 1 << ". ";
		Device::devices[i].print();
		std::cout << std::endl;
	}
}

LRESULT FAR PASCAL WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	if (message == WM_DEVICECHANGE)
	{
		switch (wParam)
		{
		case DBT_DEVICEARRIVAL:
		{
			PDEV_BROADCAST_DEVICEINTERFACE checkGUID = (PDEV_BROADCAST_DEVICEINTERFACE)lParam;
			if (checkGUID->dbcc_classguid != GUID_DEVINTERFACE_USB_DEVICE)
				break;

			Device device((PDEV_BROADCAST_DEVICEINTERFACE)lParam, hWnd);
			if (device.getName().empty())
				break;
			Device::devices.push_back(device);

			system("CLS");
			Device::devices[Device::devices.size() - 1].print();
			std::cout << " connected" << std::endl;

			printMenu();
			printDevices();
			break;
		}
		case DBT_DEVICEREMOVECOMPLETE:
		{
			Device device((PDEV_BROADCAST_DEVICEINTERFACE)lParam);
			if (device.getName().empty())
				break;
			Device::remove(device);

			system("CLS");
			device.print();
			std::cout << " disconnected" << std::endl;

			printMenu();
			printDevices();
			break;
		}
		case DBT_DEVICEQUERYREMOVE:
		{
			system("CLS");
			std::cout << "Tring to remove safely..." << std::endl;;
			printMenu();
			printDevices();
			break;
		}
		case DBT_DEVICEQUERYREMOVEFAILED:
		{
			system("CLS");
			std::cout << "Failed to remove safely" << std::endl;
			printMenu();
			printDevices();
			break;
		}
		}
	}
	return DefWindowProc(hWnd, message, wParam, lParam);
}

DWORD WINAPI initialisationThread(void*)
{
	WNDCLASSEXW wx;
	ZeroMemory(&wx, sizeof(wx));
	wx.cbSize = sizeof(WNDCLASSEX);
	wx.lpfnWndProc = (WNDPROC)WndProc;
	wx.lpszClassName = L"NONE";

	HWND hWnd = NULL;
	GUID guid = GUID_DEVINTERFACE_USB_DEVICE;
	if (RegisterClassExW(&wx))
		hWnd = CreateWindowA("NONE", "DevNotifWnd", WS_ICONIC, 0, 0, CW_USEDEFAULT, 0, 0, NULL, GetModuleHandle(nullptr), NULL);

	DEV_BROADCAST_DEVICEINTERFACE_A filter;
	filter.dbcc_size = sizeof(filter);
	filter.dbcc_classguid = guid;
	filter.dbcc_devicetype = DBT_DEVTYP_DEVICEINTERFACE;
	RegisterDeviceNotificationA(hWnd, &filter, DEVICE_NOTIFY_WINDOW_HANDLE);

	SP_DEVINFO_DATA devInfoData;
	const HDEVINFO deviceInfoSet = SetupDiGetClassDevsA(&GUID_DEVINTERFACE_USB_DEVICE, nullptr, nullptr, DIGCF_PRESENT | DIGCF_DEVICEINTERFACE);
	if (deviceInfoSet == INVALID_HANDLE_VALUE) {
		std::cout << "Cannot retrieve device information set" << std::endl;
		exitFlag = true;
		return -1;
	}

	printMenu();

	for (int i = 0; ; i++)
	{
		devInfoData.cbSize = sizeof(devInfoData);
		if (SetupDiEnumDeviceInfo(deviceInfoSet, i, &devInfoData) == FALSE)
			break;
		Device device(deviceInfoSet, devInfoData, hWnd);
		if (device.isEjectable())
		{
			Device::devices.push_back(device);
			std::cout << Device::devices.size() << " ";
			device.print();
			std::cout << std::endl;
		}

	}
	SetupDiDestroyDeviceInfoList(deviceInfoSet);

	MSG msg;

	while (true)
	{
		if (exitFlag)
			break;
		if (PeekMessage(&msg, hWnd, 0, 0, PM_REMOVE))
		{
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
	}
	return 0;
}

int main()
{
	setlocale(LC_ALL, "Russian");

	HANDLE thread = CreateThread(nullptr, 0, initialisationThread, nullptr, 0, nullptr);
	if (thread == nullptr)
	{
		std::cout << "Cannot create thread." << std::endl;
		return GetLastError();
	}

	while (true)
	{
		rewind(stdin);
		const char ch = _getch();

		if (exitFlag) {
			WaitForSingleObject(thread, INFINITE);
			CloseHandle(thread);
			for (const Device& device : Device::devices) {
				Device::remove(device);
			}
			break;
		}
		if (ch >= '1' && ch <= '9')
		{
			if (ch - '0' <= Device::devices.size())
			{
				Device& device = Device::devices[ch - '0' - 1];
				if (device.isEjectable())
					device.eject();
				else
				{
					system("CLS");
					std::cout << "Device isn't removable." << std::endl;

					printMenu();
					printDevices();
				}
				Sleep(100);
			}
		}
		else if (ch == 'e') {
			exitFlag = true;
			WaitForSingleObject(thread, INFINITE);
			CloseHandle(thread);
			for (const Device& device : Device::devices) {
				Device::remove(device);
			}
			break;
		}
	}
	return 0;
}