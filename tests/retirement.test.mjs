import test from "node:test";
import assert from "node:assert/strict";
import { futureValue, retirementProjection } from "../lib/retirement.ts";

test("future value handles zero return without division by zero",()=>{assert.equal(futureValue(10000,100,0,1),11200)});
test("later retirement improves the projected fund",()=>{const p={current_age:40,monthly_spending:5000,current_savings:50000,epf_balance:100000,prs_balance:10000,cash_investments:20000,monthly_contribution:1000,employer_contribution:500,inflation:3,life_expectancy:85,other_retirement_income:0,rental_income:0,vacancy_rate:5,property_expenses:0,healthcare_buffer:100000,education_commitments:0,desired_legacy:0,debt_balance:0};assert.ok(retirementProjection(p,65,5).fund>retirementProjection(p,60,5).fund)});
test("required saving is never negative",()=>{const p={current_age:40,monthly_spending:1000,current_savings:10000000,epf_balance:0,prs_balance:0,cash_investments:0,monthly_contribution:0,employer_contribution:0,inflation:0,life_expectancy:80,other_retirement_income:0,rental_income:0,vacancy_rate:0,property_expenses:0,healthcare_buffer:0,education_commitments:0,desired_legacy:0,debt_balance:0};assert.equal(retirementProjection(p,60,5).required,0)});
