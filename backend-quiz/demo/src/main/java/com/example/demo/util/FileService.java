package com.example.demo.util;

import com.example.demo.controller.QuestionController;
import com.example.demo.controller.QuizController;
import com.example.demo.entity.Answer;
import com.example.demo.entity.Question;
import com.example.demo.entity.QuestionType;
import com.example.demo.entity.Quiz;
import com.example.demo.model.request.*;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
@CrossOrigin(maxAge = 3600)
@Service
public class FileService {

    @Autowired
    QuestionController questionController;

    @Autowired
    QuizController quizController;

    private ModelMapper modelMapper=new ModelMapper();

    public String getValueCellAnswer(Cell cell) {
        Object cellValue = null;
        switch (cell.getCellType()) {
            case 1:
                cellValue = cell.getStringCellValue();
                return (String) cellValue;
            case 0:
                cellValue = cell.getNumericCellValue();
                return cellValue + "";
            // Add more cases for other cell types if needed
            default:
                return "Unknown cell type at row " + cell.getRowIndex() + ", column " + cell.getColumnIndex();
        }
    }

    public ResponseEntity<Object> upload(MultipartFile file, Integer numberOfSheet, String quizName) throws IOException {
        XSSFWorkbook workbook = new XSSFWorkbook(file.getInputStream());
        if (numberOfSheet == null || numberOfSheet < 0) {
            numberOfSheet = workbook.getNumberOfSheets();
        }
        for (int i = 0; i < numberOfSheet; i++) {
            QuestionRequestCreateMany questionRequestCreateMany = new QuestionRequestCreateMany();
            List<QuestionRequestCreateManyByFile>listQuestionRequestCreateManyList = new ArrayList<>();
            // Getting the Sheet at index i
            Sheet sheet = workbook.getSheetAt(i);
            System.out.println("Reading from sheet:" + sheet.getSheetName());
            // 1. You can obtain a rowIterator and columnIterator and iterate over them
            System.out.println("Iterating over Rows and Columns using Iterator");
            Iterator<Row> rowIterator = sheet.rowIterator();
            while (rowIterator.hasNext()) {
                Row row = rowIterator.next();
                if (row.getRowNum() == 0) {
                    continue;
                }
                List<Answer> answerList = new ArrayList<>();
                QuestionRequestCreateManyByFile question = new QuestionRequestCreateManyByFile();

                String questionText = (String) row.getCell(0).getStringCellValue();
                question.setQuestion(questionText);

                String typeString = (String) row.getCell(1).getStringCellValue();
                if (typeString.equals("Multiple Choice"))
                    question.setType(QuestionType.MULTIPLE_CHOICE);
                else if (typeString.equals("Single Choice"))
                    question.setType(QuestionType.SINGLE_CHOICE);
                String answerText1 = getValueCellAnswer(row.getCell(2));
                Answer answer1 = new Answer(answerText1, null);

                String answerText2 = getValueCellAnswer(row.getCell(3));
                Answer answer2 = new Answer(answerText2, null);

                String answerText3 = getValueCellAnswer(row.getCell(4));
                Answer answer3 = new Answer(answerText3, null);

                String answerText4 = getValueCellAnswer(row.getCell(5));
                Answer answer4 = new Answer(answerText4, null);

                Cell cell = row.getCell(6);
                switch (cell.getCellType()) {
                    case 1 -> {
                        String cellValue = cell.getStringCellValue();
                        // Handle string cell value
                        String[] stringArray = cellValue.split(",");
                        for (String s : stringArray) {
                            int answerIndex = Integer.parseInt(s);
                            if (answerIndex == 1)
                                answer1.setCorrect(true);
                            else if (answerIndex == 2)
                                answer2.setCorrect(true);
                            else if (answerIndex == 3)
                                answer3.setCorrect(true);
                            else if (answerIndex == 4)
                                answer4.setCorrect(true);
                            else
                                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid answer index");
                        }
                    }
                    case 0 -> {
                        int numericCellValue = (int) cell.getNumericCellValue();
                        // Handle numeric cell value
                        switch (numericCellValue) {
                            case 1 -> answer1.setCorrect(true);
                            case 2 -> answer2.setCorrect(true);
                            case 3 -> answer3.setCorrect(true);
                            case 4 -> answer4.setCorrect(true);
                            default -> {
                                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid answer index");
                            }
                        }
                    }
                    // Add more cases for other cell types if needed
                    default ->
                            System.out.println("Unknown cell type at row " + row.getRowNum() + ", column " + cell.getColumnIndex());
                }


                double time = (double) row.getCell(7).getNumericCellValue();



                question.setTime(time);

                Question questionEntity = modelMapper.map(question, Question.class);

                answer1.setQuestion(questionEntity);
                answer2.setQuestion(questionEntity);
                answer3.setQuestion(questionEntity);
                answer4.setQuestion(questionEntity);

                answerList.add(answer1);
                answerList.add(answer2);
                answerList.add(answer3);
                answerList.add(answer4);

                question.setAnswers(answerList);

                System.out.println(question.toString());


                listQuestionRequestCreateManyList.add(question) ;

            }
            questionRequestCreateMany.setListQuestion(listQuestionRequestCreateManyList);
            QuizRequestCreateByFile quizRequestCreateByFile = new QuizRequestCreateByFile(quizName);
            questionRequestCreateMany.setQuiz(quizRequestCreateByFile);

            return questionController.saveManyQuestion(questionRequestCreateMany);

        }
        System.out.println("=====================end of file====================");
        //save question in this api and return List<answer>

        return null;
    }


    public Object uploadPreview(MultipartFile file, Integer numberOfSheet) throws IOException {
        XSSFWorkbook workbook = new XSSFWorkbook(file.getInputStream());
        if (numberOfSheet == null || numberOfSheet < 0) {
            numberOfSheet = workbook.getNumberOfSheets();
        }
        QuestionRequestCreateManyPreview questionRequestCreateMany = new QuestionRequestCreateManyPreview();
        List<QuestionRequestCreateManyByFilePreview>listQuestionRequestCreateManyList = new ArrayList<>();

        for (int i = 0; i < numberOfSheet; i++) {
            // Getting the Sheet at index i
            Sheet sheet = workbook.getSheetAt(i);
            System.out.println("Reading from sheet:" + sheet.getSheetName());
            // 1. You can obtain a rowIterator and columnIterator and iterate over them
            System.out.println("Iterating over Rows and Columns using Iterator");
            Iterator<Row> rowIterator = sheet.rowIterator();
            while (rowIterator.hasNext()) {
                Row row = rowIterator.next();
                if (row.getRowNum() == 0) {
                    continue;
                }
                List<AnswerPreview> answerList = new ArrayList<>();
                QuestionRequestCreateManyByFilePreview question = new QuestionRequestCreateManyByFilePreview();

                String questionText = (String) row.getCell(0).getStringCellValue();
                question.setQuestion(questionText);

                String typeString = (String) row.getCell(1).getStringCellValue();
                if (typeString.equals("Multiple Choice"))
                    question.setType(QuestionType.MULTIPLE_CHOICE);
                else if (typeString.equals("Single Choice"))
                    question.setType(QuestionType.SINGLE_CHOICE);
                String answerText1 = getValueCellAnswer(row.getCell(2));
                AnswerPreview answer1 = new AnswerPreview(answerText1, false);

                String answerText2 = getValueCellAnswer(row.getCell(3));
                AnswerPreview answer2 = new AnswerPreview(answerText2, false);

                String answerText3 = getValueCellAnswer(row.getCell(4));
                AnswerPreview answer3 = new AnswerPreview(answerText3, false);

                String answerText4 = getValueCellAnswer(row.getCell(5));
                AnswerPreview answer4 = new AnswerPreview(answerText4, false);

                Cell cell = row.getCell(6);
                switch (cell.getCellType()) {
                    case 1 -> {
                        String cellValue = cell.getStringCellValue();
                        // Handle string cell value
                        String[] stringArray = cellValue.split(",");
                        for (String s : stringArray) {
                            int answerIndex = Integer.parseInt(s);
                            if (answerIndex == 1)
                                answer1.setIsCorrect(true);
                            else if (answerIndex == 2)
                                answer2.setIsCorrect(true);
                            else if (answerIndex == 3)
                                answer3.setIsCorrect(true);
                            else if (answerIndex == 4)
                                answer4.setIsCorrect(true);
                            else
                                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid answer index");
                        }
                    }
                    case 0 -> {
                        int numericCellValue = (int) cell.getNumericCellValue();
                        // Handle numeric cell value
                        switch (numericCellValue) {
                            case 1 -> answer1.setIsCorrect(true);
                            case 2 -> answer2.setIsCorrect(true);
                            case 3 -> answer3.setIsCorrect(true);
                            case 4 -> answer4.setIsCorrect(true);
                            default -> {
                                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid answer index");
                            }
                        }
                    }
                    // Add more cases for other cell types if needed
                    default ->
                            System.out.println("Unknown cell type at row " + row.getRowNum() + ", column " + cell.getColumnIndex());
                }


                double time = (double) row.getCell(7).getNumericCellValue();



                question.setTime(time);

                Question questionEntity = modelMapper.map(question, Question.class);

//                answer1.setQuestion(questionEntity);
//                answer2.setQuestion(questionEntity);
//                answer3.setQuestion(questionEntity);
//                answer4.setQuestion(questionEntity);

                answerList.add(answer1);
                answerList.add(answer2);
                answerList.add(answer3);
                answerList.add(answer4);

                question.setAnswers(answerList);
//                question.setQuizId(quizId);

                System.out.println(question.toString());


                listQuestionRequestCreateManyList.add(question) ;

            }


//            return questionController.saveManyQuestion(questionRequestCreateMany);


        }
        questionRequestCreateMany.setListQuestion(listQuestionRequestCreateManyList);
        return questionRequestCreateMany;
        //save question in this api and return List<answer>

    }

}
