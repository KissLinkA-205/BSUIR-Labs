//
// Created by Anzhalika Dziarkach on 23.02.2022.
//

#ifndef LAB3_CHAR_MATRIX_CUH
#define LAB3_CHAR_MATRIX_CUH

class CharMatrix {
private:
    char *matrix;
    long long lines;
    long long columns;

public:
    CharMatrix(long long lines, long long columns);
    ~CharMatrix();

    bool equals(const CharMatrix& anotherMatrix);
    char* getMatrix();
    long long getLines();
    long long getColumns();

    void printToConsole();
    void printFragmentToConsole();
    void fillWithRandomSymbols();
};


#endif //LAB3_CHAR_MATRIX_CUH
