#include "stm32g4xx.h"

void init_GPIOA(void)
{
    RCC->AHB2ENR |= RCC_AHB2ENR_GPIOAEN; // enable GPIO Port A clock
    GPIOA->MODER &= ~GPIO_MODER_MODE5; GPIOA->MODER |= GPIO_MODER_MODE5_0; // set PA5 to output
}

void delay(unsigned int value)
{
    for(unsigned int i = 0; i < value; ++i);
}

int main(void)
{
    init_GPIOA();

    while(1)
    {
        GPIOA->ODR |= GPIO_ODR_OD5;
        delay(1000000);
        GPIOA->ODR &= ~GPIO_ODR_OD5;
        delay(1000000);
    }

    return 0;
}
