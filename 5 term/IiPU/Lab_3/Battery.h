#pragma once
#include "libraries.h"

using namespace std;

class Battery
{
private:
	string powerSupply;
	string savingMode;
	string stateCharge;
	string chemistry;
	int percent;
	int lifeTime;

public:
	Battery();
	string getPowerSupply(SYSTEM_POWER_STATUS status);
	string getStateCharge(SYSTEM_POWER_STATUS status);
	string getSavingMode(SYSTEM_POWER_STATUS status);
	void printBatteryChemistry();
	friend ostream& operator<<(ostream& out, Battery battery);
};

