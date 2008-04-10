require File.dirname(__FILE__) + '/../../spec_helper'
require 'bigdecimal'

describe "BigDecimal#sign" do

  it "BigDecimal defines several constants for signs" do
    BigDecimal::SIGN_POSITIVE_INFINITE.should == 3
    BigDecimal::SIGN_NEGATIVE_INFINITE.should == -3
    BigDecimal::SIGN_POSITIVE_ZERO.should == 1
    BigDecimal::SIGN_NEGATIVE_ZERO.should == -1
    BigDecimal::SIGN_POSITIVE_FINITE.should == 2
    BigDecimal::SIGN_NEGATIVE_FINITE == -2
  end

  it "returns positive value if BigDecimal greater 0" do
    BigDecimal("1").sign.should  == BigDecimal::SIGN_POSITIVE_FINITE
    BigDecimal("1E-20000000").sign.should == BigDecimal::SIGN_POSITIVE_FINITE
    BigDecimal("1E200000000").sign.should == BigDecimal::SIGN_POSITIVE_FINITE
    BigDecimal("Infinity").sign.should == BigDecimal::SIGN_POSITIVE_INFINITE
  end

  it "returns negative value if BigDecimal smaller 0" do
    BigDecimal("-1").sign.should == BigDecimal::SIGN_NEGATIVE_FINITE
    BigDecimal("-1E-9990000").sign.should == BigDecimal::SIGN_NEGATIVE_FINITE
    BigDecimal("-1E20000000").sign.should == BigDecimal::SIGN_NEGATIVE_FINITE
    BigDecimal("-Infinity").sign.should == BigDecimal::SIGN_NEGATIVE_INFINITE
  end

  it "returns positive zero if BigDecimal equals positve zero" do
    BigDecimal("0").sign.should == BigDecimal::SIGN_POSITIVE_ZERO
    BigDecimal("0E-200000000").sign.should ==  BigDecimal::SIGN_POSITIVE_ZERO
    BigDecimal("0E200000000").sign.should ==  BigDecimal::SIGN_POSITIVE_ZERO
  end

  it "returns negative zero if BigDecimal equal negative zero" do
    BigDecimal("-0").sign.should == BigDecimal::SIGN_NEGATIVE_ZERO
    BigDecimal("-0E-200000000").sign.should == BigDecimal::SIGN_NEGATIVE_ZERO
    BigDecimal("-0E200000000").sign.should == BigDecimal::SIGN_NEGATIVE_ZERO
  end

  it "returns BigDecimal::SIGN_NaN if BigDecimal is NaN" do
    BigDecimal("NaN").sign.should == BigDecimal::SIGN_NaN
  end

end

