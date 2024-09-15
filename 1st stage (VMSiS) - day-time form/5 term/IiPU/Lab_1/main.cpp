#include "libraries.h"
#include "PciDevicesData.h"

int main() {
	setlocale(LC_ALL, "Russian");

	PciDevicesData source;
	DWORD i = 0;
	while (source.bind(i++)) {
		std::cout << "\ndevice ¹" << i << ":" << std::endl;
		std::wcout << "\tname: " << source.getName() << std::endl;
		std::wcout << "\tvendorID: " << source.getVendorID() << std::endl;
		std::wcout << "\tdeviceID: " << source.getDeviceID() << std::endl;
	}
	system("pause");
	return 0;
}