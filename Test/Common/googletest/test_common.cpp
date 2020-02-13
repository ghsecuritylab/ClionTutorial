#include "gtest/gtest.h"
#include "Calc.h"

TEST(CalcTest,test_add)
{
   EXPECT_EQ(add(1,1),2);
}

TEST(CalcTest,test_sub)
{
    EXPECT_EQ(sub(1,1),0);
}

TEST(CalcTest,test_mul)
{
    EXPECT_EQ(mul(10,10),100);
}
