#include <stdint.h>
#include "stm32g4xx.h"

void init_GPIOA(void)
{
    RCC->AHB2ENR |= RCC_AHB2ENR_GPIOAEN; // enable GPIO Port A clock
    GPIOA->MODER &= ~GPIO_MODER_MODE5; GPIOA->MODER |= GPIO_MODER_MODE5_0; // set PA5 to output
}

void init_timer2(void)
{
    RCC->APB1ENR1 |= RCC_APB1ENR1_TIM2EN; // enable clock for TIM2
    TIM2->SR &= ~TIM_SR_UIF; // clear ready flag
    TIM2->ARR = 15999999; // at 16 MHz this should trigger once per second
    TIM2->CR1 |= TIM_CR1_CEN; // enable timer 2
}

int main(void)
{
/*
    const uint16_t sinewave[] = {
       0   ,    4,   16,   36,   64,  100,  143,  194,  253,  318,  391,  469,  554,  645,  742,  844,  950, 1061,
       1175, 1293, 1414, 1538, 1663, 1790, 1918, 2047, 2176, 2304, 2431, 2556, 2680, 2801, 2919, 3033, 3144, 3250,
       3352, 3449, 3540, 3625, 3703, 3776, 3841, 3900, 3951, 3994, 4030, 4058, 4078, 4090, 4095, 4090, 4078, 4058,
       4030, 3994, 3951, 3900, 3841, 3776, 3703, 3625, 3540, 3449, 3352, 3250, 3144, 3033, 2919, 2801, 2680, 2556,
       2431, 2304, 2176, 2047, 1918, 1790, 1663, 1538, 1414, 1293, 1175, 1061,  950,  844,  742,  645,  554,  469,
        391,  318,  253,  194,  143,  100,   64,   36,   16,    4
    };
*/
    init_GPIOA();
    init_timer2();

    while(1)
    {
        GPIOA->ODR &= ~GPIO_ODR_OD5;
        while(!(TIM2->SR & 0x01));
        TIM2->SR &= ~0x01; // clear ready flag

        GPIOA->ODR |= GPIO_ODR_OD5;
        while(!(TIM2->SR & 0x01));
        TIM2->SR &= ~0x01; // clear ready flag
    }

    return 0;
}
