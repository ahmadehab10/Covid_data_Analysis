	/* Temp Table*/
  
Create temporary table PercentVaccinated
(
   Continent varchar(50),
   Location varchar(50),
   Date text,
   population numeric,
   new_vaccinations text,
   SumofVaccinations numeric
);
Insert into PercentVaccinated
Select dea.continent, dea.location,dea.date ,dea.population,	
vac.new_vaccinations,sum(Cast(vac.new_vaccinations as float)) Over
 (partition By location order by dea.location,dea.date) as SumOfVaccinations
from coviddeathsdata dea
Join Covidvaccinations vac
  on dea.date = vac.date
  and dea.location= vac.location
  where dea.continent is not null
  order by 2,3 ;
  
  select * ,(SumOfVaccinations/population)*100 as VaccinatonPercentage
  from PercentVaccinated;
  Drop temporary table if exists PercentVaccinated;
   

Select * from coviddeathsdata
Where Continent is not null
order by 3,4;



Select Location, date, total_cases,new_cases,total_deaths,population
From coviddeathsdata
order by 1,2;

/* looking at total cases vs total deaths*/
Select Location, date, total_cases,total_deaths,
(total_deaths/total_cases)*100 AS PercentageOfDeaths 
From coviddeathsdata
Where location ='Egypt'
order by 1,2;

/* Looking at unique locations in the dataset*/
Select distinct location
from coviddeathsdata;

/* Looking at Total cases vs Population*/

Select Location, date, total_cases,population,
(total_cases/population)*100 AS PercentOfPopulation 
From coviddeathsdata
Where location ='Egypt'
order by date;

/*Highest Infection rate compared to population*/

Select location,population, Max(total_cases) AS HighestInfectionCount,
Max((total_cases/population))*100 AS PercentOfPopulation
From coviddeathsdata
Group by Location, Population
Order by PercentOfPopulation DESC;

/*Countries with highest death rate*/

Select location,population, Max(Cast(total_deaths as float)) AS HighestDeathCount,
 Max(cast((total_cases/population)*100 as float)) AS PercentOfDeaths
From coviddeathsdata
Where continent is not null
Group by Location, Population
Order by PercentOfDeaths DESC;	

/*death rate by continent*/
Select Continent, Max(Cast(total_deaths as float)) AS HighestDeathCount,
 Max(cast((total_cases/population)*100 as float)) AS PercentOfDeaths
From coviddeathsdata
Where Continent is not null
Group by Continent
Order by PercentOfDeaths DESC;

/* Global Numbers*/	

Select Date, sum(new_cases) as GlobalCases, 
Sum(cast(new_deaths as float)) as GlobalDeaths,
(Sum(cast(new_deaths as float))/sum(new_cases))*100 
as GlobalDeathPercentage
From coviddeathsdata
Where Continent is not null
group by date
order by 1;


/*Looking at total vaccinations vs locations*/

Select dea.continent, dea.location,dea.date,dea.population,	
vac.new_vaccinations,sum(Cast(vac.new_vaccinations as float)) Over
 (partition By location order by dea.location,dea.date) as SumOfVaccinations
from coviddeathsdata dea
Join Covidvaccinations vac
  on dea.date = vac.date
  and dea.location= vac.location
  order by 2,3;
  
create view EgyptDeathPercentage as
Select Location, date, total_cases,total_deaths,
(total_deaths/total_cases)*100 AS PercentageOfDeaths 
From coviddeathsdata
Where location ='Egypt'
order by 1,2;

Create View EgyptTotalCases AS
Select Location, date, total_cases,population,
(total_cases/population)*100 AS PercentOfPopulation 
From coviddeathsdata
Where location ='Egypt'
order by date;

Create view HighestInfectedCountries as
Select location,population, Max(total_cases) AS HighestInfectionCount,
Max((total_cases/population))*100 AS PercentOfPopulation
From coviddeathsdata
Group by Location, Population
Order by PercentOfPopulation DESC;

Create View HighestDeathRateCountries as
Select location,population, Max(Cast(total_deaths as float)) AS HighestDeathCount,
 Max(cast((total_cases/population)*100 as float)) AS PercentOfDeaths
From coviddeathsdata
Where continent is not null
Group by Location, Population
Order by PercentOfDeaths DESC;	

create view ContinentDeathRate as 
Select Continent, Max(Cast(total_deaths as float)) AS HighestDeathCount,
 Max(cast((total_cases/population)*100 as float)) AS PercentOfDeaths
From coviddeathsdata
Where Continent is not null
Group by Continent
Order by PercentOfDeaths DESC;

Create view GlobalNumbers as
Select Date, sum(new_cases) as GlobalCases, 
Sum(cast(new_deaths as float)) as GlobalDeaths,
(Sum(cast(new_deaths as float))/sum(new_cases))*100 
as GlobalDeathPercentage
From coviddeathsdata
Where Continent is not null
group by date
order by 1;

Create View vaccinationsbyCountry as
Select dea.continent, dea.location,dea.date,dea.population,	
vac.new_vaccinations,sum(Cast(vac.new_vaccinations as float)) Over
 (partition By location order by dea.location,dea.date) as SumOfVaccinations
from coviddeathsdata dea
Join Covidvaccinations vac
  on dea.date = vac.date
  and dea.location= vac.location