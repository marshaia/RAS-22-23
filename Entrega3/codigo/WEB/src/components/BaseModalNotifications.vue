<template>
    <BaseModal title="Notificações" :is-open="isOpen" @close="$emit('close')">
        
        <div v-if="!login.notificacoes" class="flex flex-row justify-center mt-5 text-center"> <spinningButton /> </div> 
        <div v-else-if="login.notificacoes.length <= 0" class="dark:text-white text-black mt-3 text-center"> Não existem novas notificações </div>

        <div class="flex flex-col max-h-[500px] space-y-4 mt-2 overflow-y-auto no-scrollbar">
            <div v-for="msg in login.notificacoes" :key="msg.idnotificacao" class="flex flex-row border rounded-md dark:text-white text-black text-md p-3 border-rasbet-logo-gold">
                <span class="grow">{{ msg.descricao }}</span>
                <button class="flex flex-col ml-2 relative -top-2 -right-0.5 dark:text-white text-black hover:text-rasbet-logo-gold focus:text-rasbet-logo-gold"
                @click.prevent="deleteButton(msg.idnotificacao)">
                    X
                </button>
            </div>
        </div>
    </BaseModal>
</template>

<script setup lang="ts">
import BaseModal from '../components/BaseModal.vue'
import spinningButton from '../assets/spiningButton.vue'
import { loginState } from '../stores/loginStore'

const login = loginState();
login.getNotificacoes();

interface Emits {
    (e: "close"): void;
}

interface Props {
    isOpen: boolean;
}
  
defineEmits<Emits>();
defineProps<Props>();

const deleteButton = (id: number) => {
    login.changeVistoNotificacao(id);
}

</script>