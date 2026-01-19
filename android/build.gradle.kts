allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// 允许接入方修改引用的Android原生SDK版本
// Allow the access party to modify the version of the Android native SDK it references

// 如果配置文件是Groovy，就用下面的语法
// If the configuration file is Groovy, use the following syntax
//ext {
//    sudGipArtifact = 'tech.sud.gip:SudGIP:1.6.6.1277'
//}

// 如果配置文件是kts，就用下面的语法
// If the configuration file is kts, use the following syntax
//extra["sudGipArtifact"] = "tech.sud.gip:SudGIP:1.6.6.1277"

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
