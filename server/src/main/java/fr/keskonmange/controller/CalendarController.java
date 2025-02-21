package fr.keskonmange.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/calendar")
public class CalendarController {

    @GetMapping("/coming")
    public String comingPlannedRecipes(@RequestParam("days") int days) {
        return "success";
    }

    @GetMapping("/completeMonth")
    public String completeMonth(@RequestParam("previous") int previous) {
        return "success";
    }

    @GetMapping("/next")
    public String nextPlannedRecipes(@RequestParam("count") int count) {
        return "success";
    }

    @GetMapping("/today")
    public String todayRecipes() {
        return "success";
    }
}
