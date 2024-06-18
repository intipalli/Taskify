package com.tms.services;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Utilities {

	private static final Logger logger = LoggerFactory.getLogger(Utilities.class);

	private static LocalDate parseDate(String dateString) {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/dd/yyyy");
		return LocalDate.parse(dateString, formatter);
	}

	public static boolean currentDateIsAfter(String dateArgument) {
		try {
			// Parse the date argument into a LocalDate object
			LocalDate targetDate = parseDate(dateArgument);

			// Get the current date
			LocalDate currentDate = LocalDate.now();

			// Compare if current date is after the target date
			return currentDate.isAfter(targetDate);
		} catch (Exception e) {
			// Handle any parsing exceptions (e.g., invalid date format)
			System.out.println("Invalid date format or null argument: " + e.getMessage());
			return false; // Return false in case of error
		}
	}

	public static int totalTimeSpent(String startDate, String endDate) {
		String query = "SELECT TIMESTAMPDIFF(MINUTE, ?, ?) as time";
		int min = 0;
		try {
			Connection conn = DatabaseManager.getConnection();
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setString(1, startDate);
			ps.setString(2, endDate);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				min = rs.getInt("time");
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return min;
	}

	public static int totalTimeSpentDays(String startDate, String endDate) {
		String query = "SELECT DATEDIFF(?, ?) AS time";
		int days = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		// SimpleDateFormat to convert mm/dd/yyyy to yyyy-mm-dd
		SimpleDateFormat inputFormat = new SimpleDateFormat("MM/dd/yyyy");
		SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");

		try {
			// Convert startDate and endDate to yyyy-MM-dd format
			String formattedStartDate = outputFormat.format(inputFormat.parse(startDate));
			String formattedEndDate = outputFormat.format(inputFormat.parse(endDate));

			// Get connection and prepare statement
			conn = DatabaseManager.getConnection();
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, formattedEndDate);
			pstmt.setString(2, formattedStartDate);

			// Execute query and get result
			rs = pstmt.executeQuery();
			if (rs.next()) {
				days = rs.getInt("time");
			}
		} catch (SQLException | ParseException e) {
			e.printStackTrace();
		}
		return days;
	}

	public static String timeFormatter(String dateTime) {
		SimpleDateFormat inputFormatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try {
			Date date = inputFormatter.parse(dateTime);
			SimpleDateFormat outputFormatter = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
			return outputFormatter.format(date);
		} catch (ParseException e) {
			logger.error("Error parsing date in timeFormatter: {}", e.getMessage());
			return "Invalid Date"; // Handle error gracefully
		}
	}

	public static String timeFetcher() {
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
		LocalDateTime now = LocalDateTime.now();
		return dtf.format(now);
	}

	public static String getCurrentDate() {
		// Get the current date
		LocalDate currentDate = LocalDate.now();

		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/dd/yyyy");

		// Format the current date using the formatter
		String formattedDate = currentDate.format(formatter);

		return formattedDate;
	}

	public static String getCurrentDateTime() {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		return LocalDateTime.now().format(formatter);
	}

	public static long calculateDaysTaken(String startDateTime, String endDateTime) {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

		LocalDateTime start = LocalDateTime.parse(startDateTime, formatter);
		LocalDateTime end = LocalDateTime.parse(endDateTime, formatter);

		// Calculate the number of days between the two date-times
		long daysBetween = ChronoUnit.DAYS.between(start, end);

		return daysBetween;
	}

	public static String getPropertyValue(String property, String filename) {
		String propertyValue = "";
		Properties prop = new Properties();
		InputStream input = null;

		try {

			input = Thread.currentThread().getContextClassLoader().getResourceAsStream(filename);
			prop.load(input);

			propertyValue = prop.getProperty(property);
		} catch (IOException ex) {
			ex.printStackTrace();
		}
		return propertyValue;
	}

	public static Session getSessionObject() {
		Properties props = new Properties();
		try {
			props.put("mail.smtp.auth", getPropertyValue("mail.smtp.auth", "email.properties"));
			props.put("mail.smtp.starttls.enable", getPropertyValue("mail.smtp.starttls.enable", "email.properties"));
			props.put("mail.smtp.host", getPropertyValue("mail.smtp.host", "email.properties"));
			props.put("mail.smtp.port", getPropertyValue("mail.smtp.port", "email.properties"));
			props.put("mail.smtp.from", getPropertyValue("from", "email.properties"));

			System.out.println("From is: " + props.getProperty("mail.smtp.from"));

			Authenticator auth = new Authenticator() {
				@Override
				protected PasswordAuthentication getPasswordAuthentication() {
					try {
						return new PasswordAuthentication(Utilities.getPropertyValue("username", "email.properties"),
								Utilities.getPropertyValue("password", "email.properties"));
					} catch (Exception e) {
						e.printStackTrace();
					}
					return null;
				}
			};
			return Session.getInstance(props, auth);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
}
