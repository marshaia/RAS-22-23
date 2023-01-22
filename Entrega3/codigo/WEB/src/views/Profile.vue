<template>
  <div class="flex items-center justify-center space-x-6 p-4">

    <div class="flex flex-col h-full w-1/5 space-y-6">
      <infoProfile />
      <InfoPerfilWallet/>
    </div>

    <InfoPerfilHistApostas class="w-2/5 h-full" />
    <InfoPerfilHistTransac  class="w-2/5 h-full" />
  </div>
</template>

<script setup lang="ts">
import infoProfile from "../components/InfoPerfil.vue";
import InfoPerfilHistApostas from "../components/InfoPerfilHistApostas.vue";
import InfoPerfilHistTransac from "../components/InfoPerfilHistTransac.vue";
import InfoPerfilWallet from "../components/InfoPerfilWallet.vue";
</script>