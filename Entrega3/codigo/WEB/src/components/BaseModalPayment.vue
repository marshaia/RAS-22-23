<template>
    <BaseModal @close="exitButton" :title="modalTitle" :is-open="isOpen">
        
        <!--MÉTODO DE PAGAMENTO  -->
        <div v-if="showpaymentTypePage" class="bg-white dark:bg-rasbet-view-black rounded-2xl">
            <div>
                <div class="text-center dark:text-gray-400 text-black txt-md mt-1">
                    Por favor selecione o método de pagamento:
                </div>

                <div class="flex mt-8 ml-5 items-center justify-center">

                    <!--Multibanco -->
                    <button @click.prevent="method='Multibanco'"
                        class="mr-5 border-2 border-gray-500 rounded-md bg-white hover:bg-gray-200 hover:border-rasbet-logo-gold 
                        focus:bg-gray-200 focus:border-rasbet-logo-gold 
                        dark:bg-black dark:hover:bg-rasbet-view-black dark:focus:bg-rasbet-view-black">
                        <picture>
                        <source class="h-24 w-30" srcset="../assets/multibancoDark.png" media="(prefers-color-scheme:dark)">
                        <img class="h-24 w-30 p-2" src="../assets/multibanco.png">
                        </picture>
                    </button>

                    <!-- MBWay -->
                    <button @click.prevent="method='MBWay'"
                        class="mr-5 border-2 border-gray-500 rounded-md bg-white hover:bg-gray-200 hover:border-rasbet-logo-gold 
                        focus:bg-gray-200 focus:border-rasbet-logo-gold 
                        dark:bg-black dark:hover:bg-rasbet-view-black dark:focus:bg-rasbet-view-black">
                        <picture>
                        <source class="h-24 w-30" srcset="../assets/mbwayDark.png" media="(prefers-color-scheme:dark)">
                        <img class="h-24 w-30 p-2" src="../assets/mbway.png">
                        </picture>
                    </button>
                </div>

                <div v-if="errorNotSelectedMethod" class="mt-4 text-red-500 font-semibold text-sm text-center">
                    Por favor, selecione um método de pagamento
                </div>
            </div>


            <button 
            @click.prevent="afterPaymentMethod"
            class="w-full mt-8 items-center rounded-md dark:bg-opacity-40 bg-opacity-60 bg-rasbet-logo-gold px-4 py-2 text-sm font-semibold text-white uppercase 
            hover:bg-rasbet-logo-gold focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">
                SEGUINTE
            </button>

        </div>


        <!-- MONTANTE DE PAGAMENTO -->    
        <div v-else-if="showamountPage">
            <form id="amountForm">
                <label class="block text-lg mr-3 mt-1.5 font-semibold text-rasbet-logo-gold">
                    Valor
                </label>
                <input
                    @input="clearErrors"
                    type="number"
                    placeholder="0,00€"
                    class="mb-3 block text-lg w-full rounded-md py-2 px-2 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                    v-model="amount"
                    required
                />

                <div v-if="errorFetching || errorAmount" class="text-red-500 font-semibold text-sm text-center">
                    <span v-if="errorFetching">Erro no pagamento, por favor tente mais tarde!</span>
                    <span v-else-if="errorAmount">Valor inválido! </span>
                </div>
                
                <button 
                    form="amountForm"
                    @click.prevent="enviaPOST"
                    class="w-full mt-8 items-center rounded-md dark:bg-opacity-40 bg-opacity-60 bg-rasbet-logo-gold px-4 py-2 text-sm font-semibold text-white uppercase hover:bg-rasbet-logo-gold focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">
                    SEGUINTE
                </button>
            </form>

            <div class="flex justify-center">
                <button
                @click.prevent="showPayment" 
                class="text-black dark:text-white text-sm underline hover:text-rasbet-logo-gold text-center mt-5">
                    voltar
                </button>
            </div>
        </div>


        <!-- MENSAGEM DE SUCESSO / ERRO-->
        <div v-else-if="showlastPage" class="flex flex-col h-[100px] justify-center text-center ">
            <span v-if="cart.fetching"><spiningButtonVue/></span>
            <span v-else class="dark:text-white text-black">{{ (title || 'Pagamento') }} efetuado com sucesso!</span>
        </div>
    </BaseModal>
</template>

<script setup lang="ts">
import BaseModal from './BaseModal.vue'
import spiningButtonVue from '../assets/spiningButton.vue'
import { ref } from 'vue'
import { loginState } from "../stores/loginStore"
import { cartState } from "../stores/cart"
import { transacaoCarteiraPOST } from "../api/rasbetPOSTApi"

const login = loginState();
const cart = cartState();

interface Props {
    title?: string,
    isOpen: boolean,
}

interface Emits {
    (e: "close"): void;
}
  
const emit = defineEmits<Emits>();
const props = defineProps<Props>();

const modalTitle = ref("Método de " + props.title )

const amount = ref<number>();
const method = ref<string>("");

const showpaymentTypePage = ref<boolean>(true);
const showamountPage = ref<boolean>(false);
const showlastPage = ref<boolean>(false);

const errorFetching = ref<boolean>(false);
const errorAmount = ref<boolean>(false);
const errorNotSelectedMethod = ref<boolean>(false);


const enviaPOST = () => {
    amount.value = Math.ceil((amount.value ?? 0) * 100)/100;
    
    if(amount.value <= 0){
      errorAmount.value = true;
      return;
    }

    if (/Levantamento/g.test(props.title ?? "")) {                     // LEVANTAMENTO
        if ((login.user?.valorcarteira ?? 0) < amount.value) {
            errorAmount.value = true;
            return;
        }

        transacaoCarteiraPOST(login.token, -amount.value, method.value)
        .then((res) => {
            if (res.code === 200) {
                login.setUserAndToken(res);
                showLastPage();
            }
            else {
                errorFetching.value = true;
                setTimeout(exitButton, 1500);
            }
        })
    }

    else if (/Depósito/g.test(props.title ?? "")) {                     // DEPÓSITO
        transacaoCarteiraPOST(login.token, amount.value, method.value)
        .then((res) => {
            if (res.code === 200) {
                login.setUserAndToken(res);
                showLastPage();
            }
            else {
                errorFetching.value = true;
                setTimeout(exitButton, 1500);
            }
        })
    }                                            
}

const showLastPage = () => {
    showpaymentTypePage.value = false;
    showamountPage.value = false;
    showlastPage.value = true;
 
    setTimeout(exitButton,1500);
}

const showPayment = () => {
    showpaymentTypePage.value = true;
    showamountPage.value = false;
    showlastPage.value = false; 
}

const afterPaymentMethod = () => {
    if (method.value.length === 0) {
        errorNotSelectedMethod.value = true;
        return;
    }
    clearErrors();

    showpaymentTypePage.value = false;
    showamountPage.value = true;
    showlastPage.value = false;
}


const clearErrors = () => {
    errorAmount.value = false;
    errorFetching.value = false;
    errorNotSelectedMethod.value = false;
}

const exitButton = () => {
    setTimeout(() => {
      showpaymentTypePage.value = true;
      showamountPage.value = false;
      showlastPage.value = false;
      amount.value = 0;
      method.value = "";
    },400);

    clearErrors();
    emit("close");
};
</script>


<style>

input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

/* Firefox */
input[type=number] {
  -moz-appearance: textfield;
  appearance: textfield;
}
</style>