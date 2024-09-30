interface AppEnv {
  PHX_HOST: string;
}

declare global {
  interface Window {
    appEnv: AppEnv;
  }
}

export {};
