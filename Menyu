import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class InteractiveTelegramBot {

    private static final String TOKEN = "8968190895:AAFtTp5nq0m-mWMSOW0UD7_ecM-J1wTcHek";
    private static final String BASE_URL = "https://api.telegram.org/bot" + TOKEN + "/";
    
    private static final List<String> POSITIONS = new ArrayList<>();
    private static final Random RANDOM = new Random();

    public static void main(String[] args) {
        initializePositions();
        System.out.println("=== Бот запущен! Нажмите кнопку в Telegram ===");

        long offset = 0;

        while (true) {
            try {
                String urlString = BASE_URL + "getUpdates?offset=" + offset + "&timeout=30";
                URL url = new URL(urlString);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("GET");
                conn.setConnectTimeout(35000);
                conn.setReadTimeout(35000);

                if (conn.getResponseCode() == 200) {
                    BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
                    StringBuilder response = new StringBuilder();
                    String inputLine;
                    while ((inputLine = in.readLine()) != null) {
                        response.append(inputLine);
                    }
                    in.close();

                    String json = response.toString();
                    if (json.contains("update_id")) {
                        System.out.println("📥 Получено событие от Telegram: " + json);
                        offset = processUpdates(json, offset);
                    }
                }
                
                Thread.sleep(1000);

            } catch (Exception e) {
                System.err.println("⚠️ Ошибка: " + e.getMessage());
                try { Thread.sleep(5000); } catch (InterruptedException ignored) {}
            }
        }
    }

    private static void initializePositions() {
        POSITIONS.add("🍕 Пицца Пепперони");
        POSITIONS.add("🍣 Сет Суши и Роллов");
        POSITIONS.add("🌯 Сочная Шаурма");
        POSITIONS.add("🍔 Фирменный Бургер");
        POSITIONS.add("🥩 Стейк из говядины");
        POSITIONS.add("🥟 Домашние Хинкали");
        POSITIONS.add("🧀 Хачапури по-аджарски");
    }

    private static long processUpdates(String json, long currentOffset) {
        try {
            // Ищем update_id в ответе
            int uIdx = json.lastIndexOf("update_id\":");
            if (uIdx != -1) {
                int commaIdx = json.indexOf(",", uIdx);
                if (commaIdx != -1) {
                    long updateId = Long.parseLong(json.substring(uIdx + 11, commaIdx).trim());
                    currentOffset = updateId + 1;
                }
            }

            // Пытаемся найти chat id из чата или callback
            String chatId = extractChatId(json);
            if (chatId != null) {
                System.out.println("👤 Найден ID пользователя: " + chatId);
                sendRandomPosition(chatId);
            } else {
                System.out.println("⚠️ Не удалось извлечь chat_id из JSON.");
            }

        } catch (Exception e) {
            System.err.println("❌ Ошибка обработки JSON: " + e.getMessage());
        }
        return currentOffset;
    }

    private static String extractChatId(String json) {
        try {
            // Ищем ID в объекте chat или from
            String key = "\"chat\":{\"id\":";
            int idx = json.indexOf(key);
            if (idx == -1) {
                key = "\"from\":{\"id\":";
                idx = json.indexOf(key);
            }
            if (idx != -1) {
                int start = idx + key.length();
                int end = json.indexOf(",", start);
                if (end == -1) end = json.indexOf("}", start);
                return json.substring(start, end).trim().replace("\"", "");
            }
        } catch (Exception ignored) {}
        return null;
    }

    public static void sendRandomPosition(String chatId) {
        try {
            String randomDish = POSITIONS.get(RANDOM.nextInt(POSITIONS.size()));
            String text = "🎲 Случайный выбор: " + randomDish;

            URL url = new URL(BASE_URL + "sendMessage");
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/json; charset=utf-8");
            connection.setDoOutput(true);

            String jsonInputString = "{"
                    + "\"chat_id\": \"" + chatId + "\","
                    + "\"text\": \"" + text + "\","
                    + "\"reply_markup\": {"
                    + "  \"inline_keyboard\": ["
                    + "    [{\"text\": \"🎲 Крутануть еще\", \"callback_data\": \"/roll\"}],"
                    + "    [{\"text\": \"🏠 Главное меню\", \"callback_data\": \"/start\"}]"
                    + "  ]"
                    + "}"
                    + "}";

            try (OutputStream os = connection.getOutputStream()) {
                byte[] input = jsonInputString.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            connection.getResponseCode();
            connection.disconnect();
            System.out.println("✅ Успешно отправлен ответ в чат: " + chatId);

        } catch (Exception e) {
            System.err.println("❌ Ошибка отправки: " + e.getMessage());
        }
    }
}
