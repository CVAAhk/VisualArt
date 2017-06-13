// -*- mode:c++; tab-width:2; indent-tabs-mode:nil; c-basic-offset:2 -*-
/*
 *  GenericGF.cpp
 *  zxing
 *
 *  Created by Lukas Stabe on 13/02/2012.
 *  Copyright 2012 ZXing authors All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <iostream>
#include <zxing/common/reedsolomon/GenericGF.h>
#include <zxing/common/reedsolomon/GenericGFPoly.h>
#include <zxing/common/IllegalArgumentException.h>

using zxing::GenericGF;
using zxing::GenericGFPoly;
using zxing::Ref;

Ref<GenericGF> GenericGF::QR_CODE_FIELD_256(new GenericGF(0x011D, 256, 0));
Ref<GenericGF> GenericGF::DATA_MATRIX_FIELD_256(new GenericGF(0x012D, 256, 1));
  
namespace {
  int INITIALIZATION_THRESHOLD = 0;
}
  
GenericGF::GenericGF(int primitive_, int size_, int b)
  : size(size_), primitive(primitive_), generatorBase(b), initialized(false) {
  if (size <= INITIALIZATION_THRESHOLD) {
    initialize();
  }
}
  
void GenericGF::initialize() {
  expTable = std::vector<int>(size);
  logTable = std::vector<int>(size);
    
  int x = 1;
    
  for (int i = 0; i < size; i++) {
    expTable[i] = x;
    x <<= 1; // x = x * 2; we're assuming the generator alpha is 2
    if (x >= size) {
      x ^= primitive;
      x &= size-1;
    }
  }
  for (int i = 0; i < size-1; i++) {
    logTable[expTable[i]] = i;
  }
  //logTable[0] == 0 but this should never be used
  ArrayRef<int> coefficients_zero(1);
  ArrayRef<int> coefficients_one(1);

  coefficients_zero[0] = 0;
  coefficients_one[0] = 1;

  zero = Ref<GenericGFPoly>(new GenericGFPoly(this, coefficients_zero));
  one = Ref<GenericGFPoly>(new GenericGFPoly(this, coefficients_one));
  initialized = true;
}
  
void GenericGF::checkInit() {
  if (!initialized) {
    initialize();
  }
}
  
Ref<GenericGFPoly> GenericGF::getZero() {
  checkInit();
  return zero;
}
  
Ref<GenericGFPoly> GenericGF::getOne() {
  checkInit();
  return one;
}
  
Ref<GenericGFPoly> GenericGF::buildMonomial(int degree, int coefficient) {
  checkInit();
    
  if (degree < 0) {
    throw IllegalArgumentException("Degree must be non-negative");
  }
  if (coefficient == 0) {
    return zero;
  }
  ArrayRef<int> coefficients(degree + 1);
  coefficients[0] = coefficient;
    
  return Ref<GenericGFPoly>(new GenericGFPoly(this, coefficients));
}
  
int GenericGF::addOrSubtract(int a, int b) {
  return a ^ b;
}
  
int GenericGF::exp(int a) {
  checkInit();
  return expTable[a];
}
  
int GenericGF::log(int a) {
  checkInit();
  if (a == 0) {
    throw IllegalArgumentException("cannot give log(0)");
  }
  return logTable[a];
}
  
int GenericGF::inverse(int a) {
  checkInit();
  if (a == 0) {
    throw IllegalArgumentException("Cannot calculate the inverse of 0");
  }
  return expTable[size - logTable[a] - 1];
}
  
int GenericGF::multiply(int a, int b) {
  checkInit();
    
  if (a == 0 || b == 0) {
    return 0;
  }
    
  return expTable[(logTable[a] + logTable[b]) % (size - 1)];
  }
    
int GenericGF::getSize() {
  return size;
}

int GenericGF::getGeneratorBase() {
  return generatorBase;
}
