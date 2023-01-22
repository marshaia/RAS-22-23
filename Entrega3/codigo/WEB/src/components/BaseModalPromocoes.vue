<template>
    <BaseModal title="Promoções" :is-open="isOpen" @close="$emit('close')">
        
        <div v-if="!login.promocoes" class="flex flex-row justify-center mt-5 text-center"> <spinningButton /> </div> 
        <div v-else-if="login.promocoes.length <= 0" class="dark:text-white text-black mt-3 text-center"> Não existem novas notificações </div>

        <div class="flex flex-col max-h-[500px] space-y-4 mt-2 overflow-y-auto no-scrollbar">
            <div v-for="msg in login.promocoes" :key="msg.idpromocao" class="flex flex-row border rounded-md dark:text-white text-black text-md p-3 border-rasbet-logo-gold">
                <span class="grow">{{ msg.descricao }}</span>
            </div>
        </div>
    </BaseModal>
</template>

<script setup lang="ts">
import BaseModal from '../components/BaseModal.vue'
import spinningButton from '../assets/spiningButton.vue'
import { loginState } from '../stores/loginStore'

const login = loginState();
login.getPromocoes();

interface Emits {
    (e: "close"): void;
}

interface Props {
    isOpen: boolean;
}
  
defineEmits<Emits>();
defineProps<Props>();

</script>