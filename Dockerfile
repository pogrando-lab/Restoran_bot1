FROM eclipse-temurin:17-jdk
COPY InteractiveTelegramBot.java .
RUN javac InteractiveTelegramBot.java
CMD ["java", "InteractiveTelegramBot"]
