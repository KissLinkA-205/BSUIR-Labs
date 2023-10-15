#include <iostream>
#include "CharMatrix.cuh"
#include "CharMatrixService.cuh"

#define MATRIX_LINES 10000
#define MATRIX_COLUMNS 30000
#define REVERSE false

int main() {
    srand(time(nullptr));
    CharMatrix initialMatrix = CharMatrix(MATRIX_LINES, MATRIX_COLUMNS);
    CharMatrix resultCPUMatrix = CharMatrix(MATRIX_LINES, MATRIX_COLUMNS);
    CharMatrix resultGPUNotFullBlockMatrix = CharMatrix(MATRIX_LINES, MATRIX_COLUMNS);
    CharMatrix resultSharedGPUNotFullBlockMatrix = CharMatrix(MATRIX_LINES, MATRIX_COLUMNS);
    CharMatrix resultPinnedGPUNotFullBlockMatrix = CharMatrix(MATRIX_LINES, MATRIX_COLUMNS);

    initialMatrix.fillWithRandomSymbols();
    double timeCPU = CharMatrixService::serpentineBypassUsingCPU(initialMatrix, resultCPUMatrix, REVERSE);
    std::cout << "CPU: " << timeCPU << " s" << std::endl;

    double timeGPUNotFullBlock = CharMatrixService::serpentineBypassUsingGPUNotFullBlock(initialMatrix,
                                                                                         resultGPUNotFullBlockMatrix,
                                                                                         REVERSE);
    std::cout << "GPU not full block: " << timeGPUNotFullBlock << " s" << std::endl;
    std::cout << "equals (CPU & GPU not full block): " << resultCPUMatrix.equals(resultGPUNotFullBlockMatrix)
              << std::endl;

    double timeSharedGPUNotFullBlock = CharMatrixService::serpentineBypassUsingSharedGPUNotFullBlock(initialMatrix,
                                                                                                     resultSharedGPUNotFullBlockMatrix,
                                                                                                     REVERSE);
    std::cout << "shared GPU not full block: " << timeSharedGPUNotFullBlock << " s" << std::endl;
    std::cout << "equals (CPU & shared GPU not full block): "
              << resultCPUMatrix.equals(resultSharedGPUNotFullBlockMatrix)
              << std::endl;

    double timePinnedGPUNotFullBlock = CharMatrixService::serpentineBypassUsingPinnedGPUNotFullBlock(initialMatrix,
                                                                                                     resultPinnedGPUNotFullBlockMatrix,
                                                                                                     REVERSE);
    std::cout << "pinned GPU not full block: " << timePinnedGPUNotFullBlock << " s" << std::endl;
    std::cout << "equals (CPU & pinned GPU not full block): "
              << resultCPUMatrix.equals(resultPinnedGPUNotFullBlockMatrix)
              << std::endl;


    std::cout << std::endl << "initial matrix fragment: " << std::endl;
    initialMatrix.printFragmentToConsole();

    std::cout << std::endl << "CPU matrix fragment: " << std::endl;
    resultCPUMatrix.printFragmentToConsole();

    std::cout << std::endl << "GPU not full block matrix fragment: " << std::endl;
    resultGPUNotFullBlockMatrix.printFragmentToConsole();

    std::cout << std::endl << "shared GPU not full block matrix fragment: " << std::endl;
    resultSharedGPUNotFullBlockMatrix.printFragmentToConsole();

    std::cout << std::endl << "pinned GPU not full block matrix fragment: " << std::endl;
    resultPinnedGPUNotFullBlockMatrix.printFragmentToConsole();

    return 0;
}
