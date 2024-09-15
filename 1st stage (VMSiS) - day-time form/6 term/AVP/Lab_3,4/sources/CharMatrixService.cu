//
// Created by Anzhalika Dziarkach on 06.03.2022.
//

#include <iostream>
#include <chrono>
#include "CharMatrixService.cuh"

#define THREADS_PER_BLOCK  40

#define MILLISECONDS_TO_SECOND 1000

__global__ void
serpentineBypassKernelFullBlock(const char *initialMatrix, char *outputMatrix, long long lines, long long columns,
                                bool reverse) {
    long long i = blockIdx.x * blockDim.x + threadIdx.x;
    long long j = blockIdx.y * blockDim.y + threadIdx.y;
    long long initialIndex, outputIndex;

    if (reverse) {
        initialIndex = i * lines + j;
        outputIndex = (i + 1) % 2 == 0 ? i + (lines - j - 1) * columns : j * columns + i;
    } else {
        initialIndex = (i + 1) % 2 == 0 ? i + (lines - j - 1) * columns : j * columns + i;
        outputIndex = i * lines + j;
    }

    outputMatrix[outputIndex] = initialMatrix[initialIndex];
}

__global__ void
serpentineBypassKernelNotFullBlock(const char *initialMatrix, size_t initialMatrixPitch, char *outputMatrix,
                                   size_t outputMatrixPitch, long long lines, long long columns,
                                   bool reverse) {
    long long i = blockIdx.x * blockDim.x + threadIdx.x;
    long long j = blockIdx.y * blockDim.y + threadIdx.y;
    long long initialIndex, outputIndex;

    if (reverse) {
        initialIndex = j * initialMatrixPitch + i;
        outputIndex = ((j * columns + i) / lines + 1) % 2 == 0 ?
                      (lines - 1 - (j * columns + i) % lines) * outputMatrixPitch + (j * columns + i) / lines :
                      (j * columns + i) % lines * outputMatrixPitch + (j * columns + i) / lines;
    } else {
        initialIndex = ((j * columns + i) / lines + 1) % 2 == 0 ?
                       (lines - 1 - (j * columns + i) % lines) * initialMatrixPitch + (j * columns + i) / lines :
                       (j * columns + i) % lines * initialMatrixPitch + (j * columns + i) / lines;
        outputIndex = j * outputMatrixPitch + i;
    }

    if (i < columns && j < lines) {
        outputMatrix[outputIndex] = initialMatrix[initialIndex];
    }
}

__global__ void
serpentineBypassKernelSharedNotFullBlock(const char *initialMatrix, size_t initialMatrixPitch, char *outputMatrix,
                                         size_t outputMatrixPitch, long long lines, long long columns,
                                         bool reverse) {
    __shared__ char sharedMemory[THREADS_PER_BLOCK];
    long long i = blockIdx.x * blockDim.x + threadIdx.x;
    long long j = blockIdx.y * blockDim.y + threadIdx.y;
    long long initialIndex, outputIndex;

    if (reverse) {
        initialIndex = j * initialMatrixPitch + i;
        outputIndex = ((j * columns + i) / lines + 1) % 2 == 0 ?
                      (lines - 1 - (j * columns + i) % lines) * outputMatrixPitch + (j * columns + i) / lines :
                      (j * columns + i) % lines * outputMatrixPitch + (j * columns + i) / lines;
    } else {
        initialIndex = ((j * columns + i) / lines + 1) % 2 == 0 ?
                       (lines - 1 - (j * columns + i) % lines) * initialMatrixPitch + (j * columns + i) / lines :
                       (j * columns + i) % lines * initialMatrixPitch + (j * columns + i) / lines;
        outputIndex = j * outputMatrixPitch + i;
    }

    if (i < columns && j < lines) {
        sharedMemory[threadIdx.x * blockDim.y + threadIdx.y] = initialMatrix[initialIndex];
    }

    if (i < columns && j < lines) {
        outputMatrix[outputIndex] = sharedMemory[threadIdx.x * blockDim.y + threadIdx.y];
    }
}

double CharMatrixService::serpentineBypassUsingCPU(CharMatrix &initialMatrix, CharMatrix &outputMatrix, bool reverse) {
    if (initialMatrix.getColumns() != outputMatrix.getColumns() ||
        initialMatrix.getLines() != outputMatrix.getLines()) {
        std::cerr << "Exception (serpentineBypassUsingCPU): matrix sizes don't match!" << std::endl;
        return -1;
    }

    using namespace std::chrono;
    high_resolution_clock::time_point start = high_resolution_clock::now();

    long long resultPosition = 0;
    for (auto i = 0; i < initialMatrix.getColumns(); i++) {
        for (auto j = 0; j < initialMatrix.getLines(); j++) {
            if (reverse) {
                outputMatrix.getMatrix()[(i + 1) % 2 == 0 ? i + (initialMatrix.getLines() - j - 1)
                                                                * initialMatrix.getColumns() :
                                         j * initialMatrix.getColumns() +
                                         i] = initialMatrix.getMatrix()[resultPosition++];
            } else {
                outputMatrix.getMatrix()[resultPosition++] =
                        initialMatrix.getMatrix()[(i + 1) % 2 == 0 ? i + (initialMatrix.getLines() - j - 1)
                                                                         * initialMatrix.getColumns() :
                                                  j * initialMatrix.getColumns() + i];
            }
        }
    }

    high_resolution_clock::time_point end = high_resolution_clock::now();
    return duration_cast<duration<double>>(end - start).count();
}

double CharMatrixService::serpentineBypassUsingGPUFullBlock(CharMatrix &initialMatrix, CharMatrix &outputMatrix,
                                                            bool reverse) {
    if (initialMatrix.getColumns() != outputMatrix.getColumns() ||
        initialMatrix.getLines() != outputMatrix.getLines()) {
        std::cerr << "Exception (serpentineBypassUsingGPUFullBlock): matrix sizes don't match!" << std::endl;
        return -1;
    }

    cudaError_t cudaStatus = cudaSuccess;
    cudaEvent_t start, end;
    char *initialMatrixGPU, *outputMatrixGPU;
    long long lines = initialMatrix.getLines();
    long long columns = initialMatrix.getColumns();

    cudaEventCreate(&start);
    cudaEventCreate(&end);

    cudaStatus = cudaMalloc((void **) &initialMatrixGPU, lines * columns * sizeof(char));
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Exception (serpentineBypassUsingGPUFullBlock): cudaMalloc initialMatrix failed!" << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    cudaStatus = cudaMalloc((void **) &outputMatrixGPU, lines * columns * sizeof(char));
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Exception (serpentineBypassUsingGPUFullBlock): cudaMalloc outputMatrix failed!" << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    cudaEventRecord(start, nullptr);

    cudaStatus = cudaMemcpy(initialMatrixGPU, initialMatrix.getMatrix(), lines * columns * sizeof(char),
                            cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Exception (serpentineBypassUsingGPUFullBlock): cudaMemcpy initialMatrixGPU failed!" << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    cudaStatus = cudaMemcpy(outputMatrixGPU, outputMatrix.getMatrix(), lines * columns * sizeof(char),
                            cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Exception (serpentineBypassUsingGPUFullBlock): cudaMemcpy outputMatrixGPU failed!" << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    dim3 threadsPerBlock(THREADS_PER_BLOCK);
    dim3 numBlocks(columns / threadsPerBlock.x, lines / threadsPerBlock.y);
    serpentineBypassKernelFullBlock<<<numBlocks, threadsPerBlock>>>(initialMatrixGPU,
                                                                    outputMatrixGPU, lines, columns, reverse);

    cudaStatus = cudaGetLastError();
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Exception (serpentineBypassUsingGPUFullBlock): serpentineBypassKernelFullBlock failed!"
                  << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    cudaStatus = cudaMemcpy(outputMatrix.getMatrix(), outputMatrixGPU, lines * columns * sizeof(char),
                            cudaMemcpyDeviceToHost);
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Exception (serpentineBypassUsingGPUFullBlock): cudaMemcpy outputMatrix failed!" << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    cudaEventRecord(end, nullptr);
    cudaEventSynchronize(end);
    float elapsedTime;
    cudaEventElapsedTime(&elapsedTime, start, end);

    cudaFree(initialMatrixGPU);
    cudaFree(outputMatrixGPU);
    return elapsedTime / MILLISECONDS_TO_SECOND;
}

double CharMatrixService::serpentineBypassUsingGPUNotFullBlock(CharMatrix &initialMatrix, CharMatrix &outputMatrix,
                                                               bool reverse) {
    if (initialMatrix.getColumns() != outputMatrix.getColumns() ||
        initialMatrix.getLines() != outputMatrix.getLines()) {
        std::cerr << "Exception (serpentineBypassUsingGPUNotFullBlock): matrix sizes don't match!" << std::endl;
        return -1;
    }

    cudaError_t cudaStatus = cudaSuccess;
    cudaEvent_t start, end;
    char *initialMatrixGPU, *outputMatrixGPU;
    size_t initialMatrixPitch = 0, outputMatrixPitch = 0;
    long long lines = initialMatrix.getLines();
    long long columns = initialMatrix.getColumns();

    cudaEventCreate(&start);
    cudaEventCreate(&end);

    cudaStatus = cudaMallocPitch((void **) &initialMatrixGPU, &initialMatrixPitch, columns * sizeof(char), lines);
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Exception (serpentineBypassUsingGPUNotFullBlock): cudaMallocPitch initialMatrix failed!"
                  << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    cudaStatus = cudaMallocPitch((void **) &outputMatrixGPU, &outputMatrixPitch, columns * sizeof(char), lines);
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Exception (serpentineBypassUsingGPUNotFullBlock): cudaMallocPitch outputMatrix failed!"
                  << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    cudaEventRecord(start, nullptr);

    cudaStatus = cudaMemcpy2DAsync(initialMatrixGPU, initialMatrixPitch, initialMatrix.getMatrix(),
                                   columns * sizeof(char),
                                   columns * sizeof(char), lines, cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Exception (serpentineBypassUsingGPUNotFullBlock): cudaMemcpy2DAsync initialMatrixGPU failed!"
                  << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    cudaStatus = cudaMemcpy2DAsync(outputMatrixGPU, outputMatrixPitch, outputMatrix.getMatrix(),
                                   columns * sizeof(char),
                                   columns * sizeof(char), lines, cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Exception (serpentineBypassUsingGPUNotFullBlock): cudaMemcpy2DAsync outputMatrixGPU failed!"
                  << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    dim3 threadsPerBlock(THREADS_PER_BLOCK);
    dim3 numBlocks((columns + threadsPerBlock.x - 1) / threadsPerBlock.x,
                   (lines + threadsPerBlock.y - 1) / threadsPerBlock.y);
    serpentineBypassKernelNotFullBlock<<<numBlocks, threadsPerBlock>>>(initialMatrixGPU, initialMatrixPitch,
                                                                       outputMatrixGPU, outputMatrixPitch, lines,
                                                                       columns, reverse);

    cudaStatus = cudaGetLastError();
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Exception (serpentineBypassUsingGPUNotFullBlock): serpentineBypassKernelNotFullBlock failed!"
                  << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    cudaStatus = cudaMemcpy2DAsync(outputMatrix.getMatrix(), columns * sizeof(char), outputMatrixGPU, outputMatrixPitch,
                                   columns * sizeof(char), lines,
                                   cudaMemcpyDeviceToHost);
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Exception (serpentineBypassUsingGPUNotFullBlock): cudaMemcpy2DAsync outputMatrix failed!"
                  << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    cudaEventRecord(end, nullptr);
    cudaEventSynchronize(end);
    float elapsedTime;
    cudaEventElapsedTime(&elapsedTime, start, end);

    cudaFree(initialMatrixGPU);
    cudaFree(outputMatrixGPU);
    return elapsedTime / MILLISECONDS_TO_SECOND;
}

double CharMatrixService::serpentineBypassUsingSharedGPUNotFullBlock(CharMatrix &initialMatrix,
                                                                     CharMatrix &outputMatrix, bool reverse) {
    if (initialMatrix.getColumns() != outputMatrix.getColumns() ||
        initialMatrix.getLines() != outputMatrix.getLines()) {
        std::cerr << "Exception (serpentineBypassUsingSharedGPUNotFullBlock): matrix sizes don't match!" << std::endl;
        return -1;
    }

    cudaError_t cudaStatus = cudaSuccess;
    cudaEvent_t start, end;
    char *initialMatrixGPU, *outputMatrixGPU;
    size_t initialMatrixPitch = 0, outputMatrixPitch = 0;
    long long lines = initialMatrix.getLines();
    long long columns = initialMatrix.getColumns();

    cudaEventCreate(&start);
    cudaEventCreate(&end);

    cudaStatus = cudaMallocPitch((void **) &initialMatrixGPU, &initialMatrixPitch, columns * sizeof(char), lines);
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Exception (serpentineBypassUsingSharedGPUNotFullBlock): cudaMallocPitch initialMatrix failed!"
                  << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    cudaStatus = cudaMallocPitch((void **) &outputMatrixGPU, &outputMatrixPitch, columns * sizeof(char), lines);
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Exception (serpentineBypassUsingSharedGPUNotFullBlock): cudaMallocPitch outputMatrix failed!"
                  << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    cudaEventRecord(start, nullptr);

    cudaStatus = cudaMemcpy2DAsync(initialMatrixGPU, initialMatrixPitch, initialMatrix.getMatrix(),
                                   columns * sizeof(char),
                                   columns * sizeof(char), lines, cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        std::cerr
                << "Exception (serpentineBypassUsingSharedGPUNotFullBlock): cudaMemcpy2DAsync initialMatrixGPU failed!"
                << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    cudaStatus = cudaMemcpy2DAsync(outputMatrixGPU, outputMatrixPitch, outputMatrix.getMatrix(),
                                   columns * sizeof(char),
                                   columns * sizeof(char), lines, cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Exception (serpentineBypassUsingSharedGPUNotFullBlock): cudaMemcpy2DAsync outputMatrixGPU failed!"
                  << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    dim3 threadsPerBlock(THREADS_PER_BLOCK);
    dim3 numBlocks((columns + threadsPerBlock.x - 1) / threadsPerBlock.x,
                   (lines + threadsPerBlock.y - 1) / threadsPerBlock.y);
    serpentineBypassKernelSharedNotFullBlock<<<numBlocks, threadsPerBlock>>>(initialMatrixGPU, initialMatrixPitch,
                                                                             outputMatrixGPU, outputMatrixPitch, lines,
                                                                             columns, reverse);

    cudaStatus = cudaGetLastError();
    if (cudaStatus != cudaSuccess) {
        std::cerr
                << "Exception (serpentineBypassUsingSharedGPUNotFullBlock): serpentineBypassKernelSharedNotFullBlock failed!"
                << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    cudaStatus = cudaMemcpy2D(outputMatrix.getMatrix(), columns * sizeof(char), outputMatrixGPU, outputMatrixPitch,
                              columns * sizeof(char), lines, cudaMemcpyDeviceToHost);
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Exception (serpentineBypassUsingSharedGPUNotFullBlock): cudaMemcpy2DAsync outputMatrix failed!"
                  << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    cudaEventRecord(end, nullptr);
    cudaEventSynchronize(end);
    float elapsedTime;
    cudaEventElapsedTime(&elapsedTime, start, end);

    cudaFree(initialMatrixGPU);
    cudaFree(outputMatrixGPU);
    return elapsedTime / MILLISECONDS_TO_SECOND;
}

double CharMatrixService::serpentineBypassUsingPinnedGPUNotFullBlock(CharMatrix &initialMatrix,
                                                                     CharMatrix &outputMatrix, bool reverse) {
    if (initialMatrix.getColumns() != outputMatrix.getColumns() ||
        initialMatrix.getLines() != outputMatrix.getLines()) {
        std::cerr << "Exception (serpentineBypassUsingPinnedGPUNotFullBlock): matrix sizes don't match!" << std::endl;
        return -1;
    }

    cudaError_t cudaStatus = cudaSuccess;
    cudaEvent_t start, end;
    char *initialMatrixGPU, *outputMatrixGPU;
    size_t initialMatrixPitch = 0, outputMatrixPitch = 0;
    long long lines = initialMatrix.getLines();
    long long columns = initialMatrix.getColumns();

    cudaEventCreate(&start);
    cudaEventCreate(&end);

    cudaStatus = cudaHostRegister(initialMatrix.getMatrix(), columns * lines * sizeof(char), 0);
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Exception (serpentineBypassUsingPinnedGPUNotFullBlock): cudaHostRegister initialMatrix failed!"
                  << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    cudaStatus = cudaHostRegister(outputMatrix.getMatrix(), columns * lines * sizeof(char), 0);
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Exception (serpentineBypassUsingPinnedGPUNotFullBlock): cudaHostRegister outputMatrix failed!"
                  << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    cudaStatus = cudaMallocPitch((void **) &initialMatrixGPU, &initialMatrixPitch, columns * sizeof(char), lines);
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Exception (serpentineBypassUsingPinnedGPUNotFullBlock): cudaMallocPitch initialMatrix failed!"
                  << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    cudaStatus = cudaMallocPitch((void **) &outputMatrixGPU, &outputMatrixPitch, columns * sizeof(char), lines);
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Exception (serpentineBypassUsingPinnedGPUNotFullBlock): cudaMallocPitch outputMatrix failed!"
                  << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    cudaEventRecord(start, nullptr);

    cudaStatus = cudaMemcpy2DAsync(initialMatrixGPU, initialMatrixPitch, initialMatrix.getMatrix(),
                                   columns * sizeof(char),
                                   columns * sizeof(char), lines, cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        std::cerr
                << "Exception (serpentineBypassUsingPinnedGPUNotFullBlock): cudaMemcpy2DAsync initialMatrixGPU failed!"
                << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    cudaStatus = cudaMemcpy2DAsync(outputMatrixGPU, outputMatrixPitch, outputMatrix.getMatrix(),
                                   columns * sizeof(char),
                                   columns * sizeof(char), lines, cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Exception (serpentineBypassUsingPinnedGPUNotFullBlock): cudaMemcpy2DAsync outputMatrixGPU failed!"
                  << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    dim3 threadsPerBlock(THREADS_PER_BLOCK);
    dim3 numBlocks((columns + threadsPerBlock.x - 1) / threadsPerBlock.x,
                   (lines + threadsPerBlock.y - 1) / threadsPerBlock.y);
    serpentineBypassKernelSharedNotFullBlock<<<numBlocks, threadsPerBlock>>>(initialMatrixGPU, initialMatrixPitch,
                                                                             outputMatrixGPU, outputMatrixPitch, lines,
                                                                             columns, reverse);

    cudaStatus = cudaGetLastError();
    if (cudaStatus != cudaSuccess) {
        std::cerr
                << "Exception (serpentineBypassUsingPinnedGPUNotFullBlock): serpentineBypassKernelSharedNotFullBlock failed!"
                << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    cudaStatus = cudaMemcpy2D(outputMatrix.getMatrix(), columns * sizeof(char), outputMatrixGPU, outputMatrixPitch,
                              columns * sizeof(char), lines, cudaMemcpyDeviceToHost);
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Exception (serpentineBypassUsingPinnedGPUNotFullBlock): cudaMemcpy2DAsync outputMatrix failed!"
                  << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    cudaStatus = cudaHostUnregister(initialMatrix.getMatrix());
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Exception (serpentineBypassUsingPinnedGPUNotFullBlock): cudaHostUnregister initialMatrix failed!"
                  << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    cudaStatus = cudaHostUnregister(outputMatrix.getMatrix());
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Exception (serpentineBypassUsingPinnedGPUNotFullBlock): cudaHostUnregister outputMatrix failed!"
                  << std::endl;
        cudaFree(initialMatrixGPU);
        cudaFree(outputMatrixGPU);
        return -1;
    }

    cudaEventRecord(end, nullptr);
    cudaEventSynchronize(end);
    float elapsedTime;
    cudaEventElapsedTime(&elapsedTime, start, end);

    cudaFree(initialMatrixGPU);
    cudaFree(outputMatrixGPU);
    return elapsedTime / MILLISECONDS_TO_SECOND;
}
