//
// Created by Anzhalika Dziarkach on 06.03.2022.
//

#ifndef LAB3_CHAR_MATRIX_SERVICE_CUH
#define LAB3_CHAR_MATRIX_SERVICE_CUH

#include "CharMatrix.cuh"

class CharMatrixService {
public:
    static double serpentineBypassUsingCPU(CharMatrix &initialMatrix, CharMatrix &outputMatrix, bool reverse);

    static double serpentineBypassUsingGPUFullBlock(CharMatrix &initialMatrix, CharMatrix &outputMatrix, bool reverse);
    static double serpentineBypassUsingGPUNotFullBlock(CharMatrix &initialMatrix, CharMatrix &outputMatrix, bool reverse);
    static double serpentineBypassUsingSharedGPUNotFullBlock(CharMatrix &initialMatrix, CharMatrix &outputMatrix, bool reverse);
    static double serpentineBypassUsingPinnedGPUNotFullBlock(CharMatrix &initialMatrix, CharMatrix &outputMatrix, bool reverse);
};

#endif //LAB3_CHAR_MATRIX_SERVICE_CUH
