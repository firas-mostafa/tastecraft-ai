allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    fun configureProject() {
        if (plugins.hasPlugin("com.android.library") || plugins.hasPlugin("com.android.application")) {
            val android = extensions.findByName("android")
            if (android != null) {
                val getNamespace = android.javaClass.methods.firstOrNull { it.name == "getNamespace" }
                val setNamespace = android.javaClass.methods.firstOrNull { it.name == "setNamespace" }
                if (setNamespace != null && getNamespace != null) {
                    val currentNamespace = getNamespace.invoke(android)
                    if (currentNamespace == null) {
                        var packageName: String? = null
                        val manifestFile = file("src/main/AndroidManifest.xml")
                        if (manifestFile.exists()) {
                            try {
                                val manifestText = manifestFile.readText()
                                val match = Regex("package=\"([^\"]+)\"").find(manifestText)
                                if (match != null) {
                                    packageName = match.groupValues[1]
                                }
                            } catch (e: Exception) {
                                // ignore
                            }
                        }
                        if (packageName == null) {
                            packageName = project.group.toString()
                        }
                        setNamespace.invoke(android, packageName)
                    }
                }
            }
        }
    }

    if (project.state.executed) {
        configureProject()
    } else {
        project.afterEvaluate {
            configureProject()
        }
    }
}


