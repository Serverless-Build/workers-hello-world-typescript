import { defineConfig } from "cf/config";

export default defineConfig({
	worker: {
		name: "workers-hello-world-typescript",
		compatibilityDate: "2026-09-29",
		compatibilityFlags: [
			"nodejs_compat",
		],
		entrypoint: "src/index.ts",
		observability: {
			enabled: true,
		},
	},
});
