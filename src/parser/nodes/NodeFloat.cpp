/*
This Source Code Form is subject to the terms of the Mozilla
Public License, v. 2.0. If a copy of the MPL was not distributed
with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
*/

#include "../../include/parser/nodes/NodeFloat.hpp"
#include "../../include/utils.hpp"
#include "../../include/parser/ast.hpp"
#include <limits>
#include <iostream>

NodeFloat::NodeFloat(double value) {this->value = value;}
NodeFloat::NodeFloat(double value, bool isDouble) {if(isDouble) this->type = new TypeBasic(BasicType::Double); this->value = value;}
NodeFloat::NodeFloat(double value, TypeBasic* type) {this->value = value; this->type = type;}

Type* NodeFloat::getType() {
    if(this->type != nullptr) return this->type;
    this->type = new TypeBasic((this->value > std::numeric_limits<float>::max()) ? BasicType::Double :
        (BasicType::Float));
    return this->type;
}

LLVMValueRef NodeFloat::generate() {
    if(this->isMustBeFloat) {
        if(this->type == nullptr || ((TypeBasic*)this->type)->type != BasicType::Float) this->type = new TypeBasic(BasicType::Float);
        return LLVMConstReal(LLVMFloatTypeInContext(generator->context), this->value);
    }
    if(this->type == nullptr) this->type = new TypeBasic(BasicType::Double);
    else if(this->type->type == BasicType::Half) return LLVMConstReal(LLVMHalfTypeInContext(generator->context), this->value);
    else if(this->type->type == BasicType::Bhalf) return LLVMConstReal(LLVMBFloatTypeInContext(generator->context), this->value);
    return LLVMConstReal(LLVMDoubleTypeInContext(generator->context), this->value);
}

Node* NodeFloat::copy() {return new NodeFloat(this->value, (this->type == nullptr) ? nullptr : (TypeBasic*)this->type->copy());}
void NodeFloat::check() {this->isChecked = true;}
Node* NodeFloat::comptime() {return this;}