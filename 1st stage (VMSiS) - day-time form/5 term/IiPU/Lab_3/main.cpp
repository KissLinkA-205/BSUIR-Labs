#include "libraries.h"
#include "Battery.h"

using namespace std;
void power();

char a = '1';

int main() {
	setlocale(LC_ALL, "Russian");
	thread log(power);

	while(a != 0) {
		if (a = _getch()) {
			a -= '0';

			switch (a) {
			case(0):
				break;

			case(1):
				SetSuspendState(FALSE, FALSE, FALSE);
				break;

			case(2):
				SetSuspendState(TRUE, FALSE, FALSE);
				break;

			}
		}
	}
	log.join();
	return 0;
}

void power()
{
	while (a != 0) {
		system("cls");
		Battery battery;
		cout << battery << endl;
		cout << "KEYS" << endl 
	         << "  Press 0 to Exit" << endl
		     << "  Press 1 to Sleep" << endl
		     << "  Press 2 to Hibernate" << endl;
		Sleep(1000);
	}
}