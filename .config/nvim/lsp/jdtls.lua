return {
    cmd: { "C:\\Program Files/Amazon Corretto/jdk21.0.6_7/bin/java", "-Declipse.application=org.eclipse.jdt.ls.core.id1", "-Dosgi.bundles.defaultStartLevel=4", "-Declipse.product=org.eclipse.jdt.ls.core.product", "-Dlog.protocol=true", "-Dlog.level=ALL", "-Xmx1g", "--add-modules=ALL-SYSTEM", "--add-opens", "java.base/java.util=ALL-UNNAMED", "--add-opens", "java.base/java.lang=ALL-UNNAMED", "-jar", "C:\\Users\\4r73m190r0s\\AppData\\Local/jdt-language-server-1.45.0-202502271238/plugins/org.eclipse.equinox.launcher_1.6.1000.v20250131-0606.jar", "-configuration", "C:\\Users\\4r73m190r0s\\AppData\\Local/jdt-language-server-1.45.0-202502271238/config_win", "-data", "c:\\Users\\4r73m190r0s\\.jdtls\\jdtlstest" }
	--  list of file that exists in root of the project
	root_markers = {
		"settings.gradle",
		"settings.gradle.kts",
		"pom.xml",
		"build.gradle",
		"mvnw",
		"gradlew",
		"build.gradle",
		"build.gradle.kts",
		".git",
	},
}
