<template>
    <BaseModal @close="exitButton" :title="modalTitle" :is-open="isOpen">
        
        <!--MÉTODO DE PAGAMENTO  -->
        <div v-if="paymentTypePage" class="bg-white dark:bg-rasbet-view-black rounded-2xl">
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

                    <!-- Wallet -->
                    <button @click.prevent="method='Carteira'"
                        class="mr-5 border-2 border-gray-500 rounded-md bg-white hover:bg-gray-200 hover:border-rasbet-logo-gold 
                        focus:bg-gray-200 focus:border-rasbet-logo-gold 
                        dark:bg-black dark:hover:bg-rasbet-view-black dark:focus:bg-rasbet-view-black">
                        <img class="h-24 p-2" src="../assets/wallet.png" alt="wallet icon" />
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

                <div v-if="errorNotSelectedMethod || errorCarteira" class="mt-4 text-red-500 font-semibold text-sm text-center">
                    <span v-if="errorNotSelectedMethod">Por favor, selecione um método de pagamento</span>
                    <span v-else-if="errorCarteira">Fundos insuficientes!</span>
                </div>
            </div>


            <button 
            @click.prevent="afterPaymentMethod"
            class="w-full mt-8 items-center rounded-md dark:bg-opacity-40 bg-opacity-60 bg-rasbet-logo-gold px-4 py-2 text-sm font-semibold text-white uppercase 
            hover:bg-rasbet-logo-gold focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">
                NEXT
            </button>

        </div>

        <!-- MENSAGEM DE SUCESSO / ERRO-->
        <div v-else-if="lastPage" class="flex flex-col h-[100px] justify-center text-center ">
            <span v-if="cart.fetching"><spiningButtonVue/></span>
            <span v-else-if="errorPagamentoAposta" class="text-red-500">Erro ao efetuar pagamento da aposta. Por favor tente mais tarde!</span>
            <span v-else class="dark:text-white text-black"> Pagamento de aposta efetuado com sucesso!</span>
        </div>
    </BaseModal>
</template>

<script setup lang="ts">
import BaseModal from './BaseModal.vue'
import spiningButtonVue from '../assets/spiningButton.vue'
import { ref } from 'vue'
import { loginState } from "../stores/loginStore"
import { cartState } from "../stores/cart"

const login = loginState();
const cart = cartState();

interface Props {
    isOpen: boolean,
}

interface Emits {
    (e: "close"): void;
}
  
const emit = defineEmits<Emits>();
defineProps<Props>();

const modalTitle = ref("Método de Pagamento")

const method = ref<string>("");

const paymentTypePage = ref<boolean>(true);
const lastPage = ref<boolean>(false);

const errorFetching = ref<boolean>(false);
const errorNotSelectedMethod = ref<boolean>(false);
const errorPagamentoAposta = ref<boolean>(false);
const errorCarteira = ref<boolean>(false);


const afterPaymentMethod = () => {
    if (method.value.length === 0) {
        errorNotSelectedMethod.value = true;
        return;
    }
    
    clearErrors();
    enviaAposta(method.value === 'Carteira' ? true : false);
}


const enviaAposta = (carteira : boolean) => {

    const valorApagar = ref<number>(0);
    if (cart.aposta.simples) {
        cart.aposta.items.forEach((value,key) => {
            valorApagar.value += value.valor;
        })
    }
    else valorApagar.value = cart.aposta.valorTotal;

    if (!login.loggedIn) return;
    // Fundos insuficientes na carteira
    else if (carteira && ((login.user?.valorcarteira ?? 0) < valorApagar.value)) errorCarteira.value = true;
    else {
        showlastPage();

        cart.enviaAposta(login.token,carteira, valorApagar.value).then((res) => {
            if (res.code === 200) {
                errorPagamentoAposta.value = false
                cart.clearCart();
            }
            else errorPagamentoAposta.value = true;
        })
    }

}

const showlastPage = () => {
    paymentTypePage.value = false;
    lastPage.value = true;
 
    setTimeout(exitButton,1500);
}

const clearErrors = () => {
    errorFetching.value = false;
    errorNotSelectedMethod.value = false;
    errorPagamentoAposta.value = false;
    errorCarteira.value = false;
}

const exitButton = () => {
    setTimeout(() => {
      paymentTypePage.value = true;
      lastPage.value = false;
    },400);
    clearErrors();
    emit("close");
};
</script>